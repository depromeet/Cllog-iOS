//
//  ClLogSessionViewModel.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Combine
import AVFoundation

public protocol ClLogSessionOutputInterface {
    var stopVidesPublisher: AnyPublisher<Void, Never> { get }
    var startVideosPublisher: AnyPublisher<URL, Never> { get }
}

public protocol ClLogSessionInputInterface: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: (any Error)?)
    
    func onStartRecord(to fileURL: URL)
    func onStopRecord()
}

public protocol ClLogSessionViewModelInterface {
    var input: any ClLogSessionInputInterface { get }
    var output: any ClLogSessionOutputInterface { get }
}

public class ClLogSessionViewModel: NSObject, ClLogSessionViewModelInterface {
    
    // MARK: - ViewModel Interface
    public var input: any ClLogSessionInputInterface { self }
    public var output: any ClLogSessionOutputInterface { self }
    
    private let stopVidesSubject: PassthroughSubject<Void, Never> = .init()
    private let starVidesSubject: PassthroughSubject<URL, Never> = .init()
    
}

extension ClLogSessionViewModel: ClLogSessionInputInterface {
    
    public func fileOutput(_ output: AVCaptureFileOutput,
                           didFinishRecordingTo outputFileURL: URL,
                           from connections: [AVCaptureConnection],
                           error: (any Error)?) {
        
    }
    
    public func onStartRecord(to fileURL: URL) {
        starVidesSubject.send(fileURL)
    }
    
    public func onStopRecord() {
        stopVidesSubject.send(())
    }
}
extension ClLogSessionViewModel: ClLogSessionOutputInterface {
    public var stopVidesPublisher: AnyPublisher<Void, Never> {
        return stopVidesSubject.eraseToAnyPublisher()
    }
    
    public var startVideosPublisher: AnyPublisher<URL, Never> {
        return starVidesSubject.eraseToAnyPublisher()
    }
}
