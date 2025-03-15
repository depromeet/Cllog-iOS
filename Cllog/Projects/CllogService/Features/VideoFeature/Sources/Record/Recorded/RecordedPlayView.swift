//
//  RecordedPlayView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import AVFoundation

extension AVPlayer: RecordedPlayerable {}

public class RecordedPlayView: UIView {
    private let viewModel: RecordedPlayViewModel
    private let player: AVPlayer
    
    private let sessionQueue = DispatchQueue(label: "RecordingPlay.Session.Queue")
    
    init(frame: CGRect = .zero, viewModel: RecordedPlayViewModel) {
        self.viewModel = viewModel
        self.player = AVPlayer(url: viewModel.videoURL)
        super.init(frame: frame)
        self.viewModel.configurePlayer(with: player)
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.frame = bounds
    }
    
    public override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    private func setupPlayer() {
        if let playerLayer = self.layer as? AVPlayerLayer {
            playerLayer.player = player
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
}


