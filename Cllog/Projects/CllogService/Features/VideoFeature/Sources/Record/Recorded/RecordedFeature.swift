//
//  RecordedFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import DesignKit

import ComposableArchitecture
import UIKit

@Reducer
public struct RecordedFeature {
    
    @Dependency(\.videoUsecase) var videoUsecase
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Dialog>?
        @Presents var cragAlert: AlertState<Action.Dialog>?
        
        let fileName: String
        let path: URL
        var duration: String = ""
        let viewModel: RecordedPlayViewModel
        var progress: CGFloat = .zero
        
        var image: UIImage?
        
        var climbingResult: ClimbingResult?
        
        var selectedDesignCrag: DesignCrag?
        
        var designGrades: [DesignGrade] = [
            .init(name: "블루", color: .init(hex: "#0000ff")),
            .init(name: "블루", color: .init(hex: "#0000ff")),
            .init(name: "블루", color: .init(hex: "#0000ff"))
        ]
        
        // bottomSheet
        var showSelectCragBottomSheet = false
        var designCrag: [DesignCrag] = [
            DesignCrag(name: "강남점", address: "서울 강남구"),
            DesignCrag(name: "홍대점", address: "서울 마포구"),
            DesignCrag(name: "신촌점", address: "서울 서대문구")
        ]
        
        var showSelectCragDifficultyBottomSheet = false
        
        public enum ClimbingResult: Sendable {
            case success
            case failture
        }
        
        public init(fileName: String, path: URL) {
            self.fileName = fileName
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: BindableAction, Equatable {
        
        case onAppear
        
        case startListeningPlayTime
        case startListeningEndPlay
        
        case timerTicked(CMTime, CMTime)
        
        case editButtonTapped
        case moveEditRecord(URL)
        
        case pause
        case closeButtonTapped
        case close
        
        case successTapped
        case failtureTapped
        
        case upload(type: UploadType, image: UIImage)
        
        case alert(PresentationAction<Dialog>)
        case cragAlert(PresentationAction<Dialog>)
        case binding(BindingAction<State>)
        
        case cragisPresentAction(Bool)
        case cragNameSkipButtonTapped
        case cragName(keyWord: String)
        case cragSaveButtonTapped(DesignCrag)
        
        case cragBottomSaveButtonTapped(DesignCrag)
        
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
        
        public enum UploadType: Equatable {
            case success
            case failture
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(reduceCore)
            .ifLet(\.alert, action: \.alert)
    }
    
}

extension RecordedFeature {
    
    private func reduceCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.viewModel.play()
            return .merge(
                .send(.startListeningPlayTime),
                .send(.startListeningEndPlay)
            )
            
        case .startListeningEndPlay:
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await _ in viewModel.playEndAsyncStream {
                    _ = await viewModel.seek(.zero)
                    viewModel.play()
                }
            }.cancellable(id: "EndPlay", cancelInFlight: true)
            
        case .startListeningPlayTime:
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await (playTime, totalduration) in viewModel.playTimeAsyncStream {
                    await send(.timerTicked(playTime, totalduration))
                }
            }.cancellable(id: "PlayTime", cancelInFlight: true)
            
        case .timerTicked(let playTime, let duration):
            let totalTime = CGFloat(CMTimeGetSeconds(duration))
            let currentTime = CGFloat(CMTimeGetSeconds(playTime))
            state.duration = playTime.formatTimeInterval()
            state.progress = currentTime/totalTime
            return .none
            
        case .editButtonTapped:
            return .merge(
                .send(.moveEditRecord(state.path)),
                .send(.pause)
            )
            
        case .pause:
            state.viewModel.pause()
            return .none
            
        case .moveEditRecord:
            return .none
            
        case .closeButtonTapped:
            state.alert = AlertState {
                TextState("기록 저장 취소")
            } actions: {
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
            } message: {
                TextState("이 페이지를 나가면 촬영하신 영상이 저장되지 않아요")
            }
            return .run { send in
                await send(.pause)
            }
            
        case .close:
            return .none
            
        case .successTapped:
            state.climbingResult = .success
            state.showSelectCragBottomSheet = true
            return .run { send in
                await send(.pause)
            }
//            return .merge(
//                .send(.pause),
//                .run(operation: { [state] send in
//                    do {
//                        let generator = AVAssetImageGenerator(asset: AVAsset(url: state.path))
//                        generator.appliesPreferredTrackTransform = true
//                        let cmTime = CMTime(seconds: 0, preferredTimescale: 600)
//                        let thumbnail = try await generator.image(at: cmTime)
//                        await send(.upload(type: .success, image: UIImage(cgImage: thumbnail.image)))
//                        
//                    } catch {
//                        print("에러")
//                    }
//                })
//            )
            
        case .upload(let type, let image):
            return .run { send in
                do {
                    let videothumbnails = try await videoUsecase.execute(name: "MyImages", fileName: "MyImages.png", mimeType: "image/png", value: image.resizedPNGData()!)
                    print("videothumbnails : \(videothumbnails)")
                } catch {
                    print("videothumbnails error")
                }
            }
        case .failtureTapped:
            state.climbingResult = .success
            state.showSelectCragBottomSheet = true
            return .run { send in
                await send(.pause)
            }
            
        case .alert(.presented(.confirm)):
            print("확인")
            return .none
            
        case .alert(.presented(.cancel)):
            print("취소")
            return .none
        case .alert(.dismiss):
            state.viewModel.play()
            return .none
            
        case .cragAlert(let action):
            switch action {
            case .dismiss:
                return .none
            case .presented(let dilogAction):
                switch dilogAction {
                case .cancel:
                    return .none
                case .confirm:
                    return .none
                }
            }
            
        case .binding(_):
            return .none
            
        case .cragisPresentAction(let isPresent):
            // 화면 닫고
            state.showSelectCragBottomSheet = isPresent
            
            return .run { send in
                await send(.onAppear)
            }
            
        case .cragNameSkipButtonTapped:
            // 암장을 건너뛰겠습니까?
            state.cragAlert = AlertState {
                TextState("암장 정보 입력 건너뛰기")
            } actions: {
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
            } message: {
                TextState("임장 입력을 하지 않으면 기록은 가능하지만,\n암장 관련 정보는 저장되지 않아요")
            }
            
            return .none
            
        case .cragName(let keyWord):
            return .none
            
        case .cragSaveButtonTapped(let designCrag):
            state.showSelectCragBottomSheet = false
            state.selectedDesignCrag = designCrag
            return .run { [designCrag] send in
                await send(.cragBottomSaveButtonTapped(designCrag))
            }
            
        case .cragBottomSaveButtonTapped(let designCrag):
            state.showSelectCragDifficultyBottomSheet = true
            return .none
        }
    }
}

extension UIImage {
    func resizedPNGData(targetSizeInBytes: Int = 1_000_000) -> Data? {
        guard var currentData = self.pngData() else { return nil }
        
        // 이미지의 해상도를 줄여서 targetSizeInBytes 미만이 될 때까지 반복
        var currentImage = self
        let scaleFactor: CGFloat = 0.9
        
        while currentData.count > targetSizeInBytes,
              currentImage.size.width > 100, currentImage.size.height > 100 {
            let newSize = CGSize(width: currentImage.size.width * scaleFactor,
                                 height: currentImage.size.height * scaleFactor)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            currentImage.draw(in: CGRect(origin: .zero, size: newSize))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                break
            }
            UIGraphicsEndImageContext()
            
            currentImage = resizedImage
            if let data = currentImage.pngData() {
                currentData = data
            } else {
                break
            }
        }
        
        return currentData.count <= targetSizeInBytes ? currentData : nil
    }
}
//
//class NetworkManager {
//    static let shared = NetworkManager()
//    private init() {}
//    
//    /// 이미지를 multipart/form-data 방식으로 업로드하는 메서드
//    /// - Parameters:
//    ///   - url: 업로드할 서버 URL
//    ///   - image: 업로드할 UIImage 객체
//    ///   - fileName: 서버에 전송할 파일 이름 (예: "example.png")
//    ///   - parameters: 추가로 전송할 텍스트 파라미터 (옵션)
//    ///   - completion: 업로드 완료 후 반환되는 결과 클로저
//    func uploadImage(url: URL,
//                     image: UIImage,
//                     fileName: String = "example.png",
//                     parameters: [String: String] = [:],
//                     completion: @escaping (Result<Data, Error>) -> Void) {
//        
//        // 필요하다면 추가 헤더 (여기서는 accept 헤더만 추가)
//        let headers: HTTPHeaders = [
//            "Accept": "*/*",
//            "Authorization": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxNSIsInVzZXJJZCI6MTUsImxvZ2luSWQiOiJ0ZXN0MTIzIiwicHJvdmlkZXIiOiJMT0NBTCIsImV4cCI6MTc0MjM4NDAwOX0.2MNvThmheMjEPpbUYs0hkLBt5rGIwWkTL6l04Fbuoikccw_zeg80zGUgRqkZ_N1xnQ6c3NITtIungyL2z-xBcw"
//        ]
//        
//        // Alamofire의 upload 메서드 사용
//        AF.upload(multipartFormData: { multipartFormData in
//            // 1. 이미지 데이터를 file 필드로 추가 (서버가 file= 으로 받길 기대)
//            if let imageData = image.pngData() {
//                multipartFormData.append(imageData,
//                                         withName: "file",
//                                         fileName: fileName,
//                                         mimeType: "image/png")
//            }
//            
//            // 2. 추가 텍스트 파라미터가 있다면 함께 추가
//            for (key, value) in parameters {
//                if let valueData = value.data(using: .utf8) {
//                    multipartFormData.append(valueData, withName: key)
//                }
//            }
//        },
//                  to: url,
//                  method: .post,
//                  headers: headers)
//        .validate()  // HTTP 상태 코드 200~299 확인
//        .responseData { response in
//            switch response.result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
//public struct VideoUploadDTOss: Codable {
//    let fileUrl: String
//}
//
//struct BaseResponseDTOs<T: Decodable>: Decodable {
////    let success: Bool
//    let data: T?
////    let error: ErrorResponseDTO?
//}
