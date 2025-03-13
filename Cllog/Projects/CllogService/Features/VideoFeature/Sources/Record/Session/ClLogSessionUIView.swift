//
//  ClLogSessionView.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVFoundation

public final class ClLogSessionUIView: UIView {
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var movieOutput: AVCaptureMovieFileOutput?
    
    private let fileOutputclosure: (URL, (any Error)?, TimeInterval) -> Void
    private var playTime: (String) -> Void
    
    private var startTime: DispatchTime?
    private var timer: Timer?

    init(
        fileOutputclosure: @escaping (URL, (any Error)?, TimeInterval) -> Void,
        playTime: @escaping (String) -> Void
    ) {
        self.fileOutputclosure = fileOutputclosure
        self.playTime = playTime
        super.init(frame: UIScreen.main.bounds)
        setupSession()
    }
    
    public var isRecording: Bool {
        movieOutput?.isRecording ?? false
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
    private func setupSession() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        guard let session = captureSession,
              let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else {
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            }
            
            let movieFileOutput = AVCaptureMovieFileOutput()
            if session.canAddOutput(movieFileOutput) {
                session.addOutput(movieFileOutput)
                self.movieOutput = movieFileOutput
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
            if let previewLayer = previewLayer {
                layer.addSublayer(previewLayer)
            }
            
            session.startRunning()
        } catch {
            print("캡쳐 세션 설정 에러: \(error)")
        }
    }
    
    func startRecording(to fileURL: URL) {
        guard let movieOutput = movieOutput, !movieOutput.isRecording else { return }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
        
        print("fileURLfileURL:::   \(fileURL)")
        
        movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        startTime = DispatchTime.now()
        startTimer()
    }
    
    func stopRecording() {
        guard let movieOutput = movieOutput, movieOutput.isRecording else { return }
        movieOutput.stopRecording()
    }
    
    func stopSession() {
        captureSession?.stopRunning()
        timer?.invalidate()
        timer = nil
    }
    
    // Timer를 이용해 1초마다 경과 시간을 출력합니다.
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = self.formattedElapsedTime()
            self.playTime(elapsed)
        }
    }
    
    // DispatchTime을 사용해 경과 시간을 계산 (초 단위)
    private func getElapsedTime() -> TimeInterval {
        guard let start = startTime else { return 0 }
        let now = DispatchTime.now()
        let nanoTime = now.uptimeNanoseconds - start.uptimeNanoseconds
        return TimeInterval(nanoTime) / 1_000_000_000
    }
    
    private func formattedElapsedTime() -> String {
        let elapsedSeconds = Int(getElapsedTime())
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

}

extension ClLogSessionUIView: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: (any Error)?
    ) {
        self.fileOutputclosure(outputFileURL, error, getElapsedTime())
    }
}
