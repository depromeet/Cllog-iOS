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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSession()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSession()
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
        movieOutput.startRecording(to: fileURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        guard let movieOutput = movieOutput, movieOutput.isRecording else { return }
        movieOutput.stopRecording()
    }
}

extension ClLogSessionUIView: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: (any Error)?
    ) {
        
    }
}
