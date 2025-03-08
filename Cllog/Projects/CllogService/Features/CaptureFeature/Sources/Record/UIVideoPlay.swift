//
//  UIVideoPlay.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI
import AVFoundation

final class UIVideoPlay: UIView {

    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(frame: UIScreen.main.bounds)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let player = AVPlayer(url: fileURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        player.play()
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { [weak self] _ in
            playerLayer.removeFromSuperlayer()
            self?.configure()
        }
    }
}

struct VideoPlayView: UIViewRepresentable {
    
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func makeUIView(context: Context) -> UIVideoPlay {
        return UIVideoPlay(fileURL: fileURL)
    }
    
    func updateUIView(_ uiView: UIVideoPlay, context: Context) {
        
    }
}
