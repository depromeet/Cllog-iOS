//
//  RecordedFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import ComposableArchitecture
import UIKit

@Reducer
public struct RecordedFeature {
    
    @Dependency(\.videoUsecase) var videoUsecase
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        let fileName: String
        let path: URL
        var duration: String = ""
        let viewModel: RecordedPlayViewModel
        var progress: CGFloat = .zero
        
        var image: UIImage?
        
        
        public init(fileName: String, path: URL) {
            self.fileName = fileName
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: Equatable {
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
            return .merge(
                .send(.pause),
                .run(operation: { [state] send in
                    do {
                        let generator = AVAssetImageGenerator(asset: AVAsset(url: state.path))
                        generator.appliesPreferredTrackTransform = true
                        let cmTime = CMTime(seconds: 0, preferredTimescale: 600)
                        let thumbnail = try await generator.image(at: cmTime)
                        await send(.upload(type: .success, image: UIImage(cgImage: thumbnail.image)))
                        
                    } catch {
                        print("에러")
                    }
                })
            )

        case .upload(let type, let image):
//            state.image = image
            
            return .run { send in
                do {
                    let response = try await videoUsecase.execute(name: "asdf", fileName: "123123", min: "image/png", value: image.resizedPNGData()!)
                    print("image :: response: \(response)")
                } catch {
                    print("image :: error: \(error)")
                }
            }
        case .failtureTapped:
            return .none
            
        case .alert(.presented(.confirm)):
            print("확인")
            return .none
            
        case .alert(.presented(.cancel)):
            print("취소")
            return .none
        case .alert(.dismiss):
            state.viewModel.play()
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
