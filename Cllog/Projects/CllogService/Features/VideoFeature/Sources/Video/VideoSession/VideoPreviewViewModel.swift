//
//  VideoPreviewViewModel.swift
//  VideoFeature
//
//  Created by saeng lin on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

public class VideoPreviewViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published private(set) var session = AVCaptureSession()
    
    private let videoOutput = AVCaptureVideoDataOutput()
    private let sessionQueue = DispatchQueue(label: "CamerModel.Session.Queue")
    private let outputQueue = DispatchQueue(label: "CamerModel.Output.Queue")
    
    deinit {
        print("deinit: \(Self.self)")
    }
    
    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        if session.canSetSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        } else if session.canSetSessionPreset(.high) {
            session.sessionPreset = .high
        } else {
            session.sessionPreset = .medium
        }
        
        guard let videoDevice = AVCaptureDevice.default(for: .video),
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
            
            videoOutput.setSampleBufferDelegate(self, queue: outputQueue)
            if session.canAddOutput(videoOutput) {
                session.addOutput(videoOutput)
            }
            
            session.commitConfiguration()
            
        } catch {
            print("캡쳐 세션 설정 에러: \(error)")
        }
    }
    
    public func startSession() {
        guard !session.isRunning else {  return }
        sessionQueue.async { [weak session] in
            session?.startRunning()
        }
    }
    
    public func stopSession() {
        guard session.isRunning else {  return }
        sessionQueue.async { [weak session] in
            session?.stopRunning()
        }
    }
    
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) { }
}
