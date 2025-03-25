//
//  VideoRecordRepositry.swift
//  Data
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import VideoDomain

import Networker
import Starlink
import Swinject

public struct VideoRecordRepository: VideoRepository {

    private let dataSource: VideoDataSource
    
    public init(
        dataSource: VideoDataSource
    ) {
        self.dataSource = dataSource
    }
    
    
    /// 비디오 저장 기능 - path
    /// - Parameter fileURL: 비디오 경로
    public func saveVideo(fileURL: URL) async throws {
        let fileManager = FileManager.default
        // 앱의 Documents 디렉토리 경로를 가져옵니다.
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents 디렉토리를 찾을 수 없습니다.")
            return
        }
        
        // 목적지 URL 생성 (같은 파일명 사용)
        let destinationURL = documentsDirectory.appendingPathComponent(fileURL.lastPathComponent)
        
        do {
            // 이미 동일한 파일이 존재하면 삭제합니다.
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            // 파일을 복사합니다.
            try fileManager.copyItem(at: fileURL, to: destinationURL)
            print("파일이 성공적으로 저장되었습니다: \(destinationURL)")
        } catch {
            print("파일 저장 중 에러 발생: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 비디오 읽어오는 기능 - 테스트
    /// - Parameter fileName: 파일명 (path xxxx) - RecordingFeature에서 저장된 fileName
    /// - Returns: 저장된 path
    public func readSavedVideo(fileName: String) async throws -> URL? {
        let fileManager = FileManager.default
        
        // 앱의 Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents 디렉토리를 찾을 수 없습니다.")
            return nil
        }
        
        // 파일 경로 생성
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 파일 존재 여부 확인
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                // 파일 데이터를 읽어옵니다.
                let data = try Data(contentsOf: fileURL)
                print("파일 읽기 성공: \(fileURL)")
                return fileURL
            } catch {
                print("파일 읽기 중 에러 발생: \(error.localizedDescription)")
                return nil
            }
        } else {
            print("파일이 존재하지 않습니다: \(fileURL)")
            return nil
        }
    }
    
    public func uploadVideo() async throws {
        
    }
    
    public func uploadVideo(fileURL: URL) async throws {
//        let model: Emtpy = try await provider.request(VideoTarget())
    }
    
    public func uploadVideoThumbnail(
        name: String,
        fileName: String,
        min: String,
        value: Data
    ) async throws -> Videothumbnails {
        return try await dataSource.uploadThumbnail(name: name, fileName: fileName, min: min, data: value).toDomain()
    }
    
}
