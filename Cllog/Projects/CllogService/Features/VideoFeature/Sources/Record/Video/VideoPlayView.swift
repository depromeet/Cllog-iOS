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
import Combine

final class VideoPlayView: UIView {
    
    private let viewModel: any VideoPlayViewModelInterface
    private var cancellables = Set<AnyCancellable>()
    private var addPeriodicTimeObserver: Any?
    private var playTime: (String, CMTime) -> Void
    private var playerLayer: AVPlayerLayer?
    
    public init(
        viewModel: any VideoPlayViewModelInterface,
        playTime: @escaping (String, CMTime) -> Void
    ) {
        self.viewModel = viewModel
        self.playTime = playTime
        super.init(frame: UIScreen.main.bounds)
        
        bind()
        
        viewModel.input.onInitialize()
    }
    
    deinit {
        print("deinit: \(Self.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        
        viewModel.output.playerConfigurePublisher
            .sink { [weak self] fileURL in
                guard let self = self else { return }
                self.configureUI(for: fileURL)
                
            }.store(in: &cancellables)
        
        viewModel.output.playerTimePublisher
            .sink { [weak self] playTimeString, currentTime in
                guard let self = self else { return }
                self.playTime(playTimeString, currentTime)
            }.store(in: &cancellables)
        
        viewModel.output.playerReplayPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                // replay 이베늩
                self.playerLayer?.player?.seek(to: .zero) { _ in
                    self.playerLayer?.player?.play()
                }
            }.store(in: &cancellables)
        
        viewModel.output.playerSeekingPublisher
            .sink { [weak self] time in
                self?.playerLayer?.player?.seek(to: time)
            }.store(in: &cancellables)
    }
    
    private func configureUI(for fileURL: URL) {
        let player = AVPlayer(url: fileURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.playerLayer = playerLayer
        layer.addSublayer(playerLayer)
        
        self.configureNotification(player: player)
        
        playerLayer.player?.play()
    }
    
    private func configureNotification(player: AVPlayer) {
        addPeriodicTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: .main) { [weak self] time in
            self?.viewModel.input.onPlayerTime(for: time)
        }
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.input.onPlayerDidFinish()
        }
    }
}

struct VideoPlay: UIViewRepresentable {
    
    private var viewModel: any VideoPlayViewModelInterface
    private let playTime: (String, CMTime) -> Void
    
    public init(
        viewModel: any VideoPlayViewModelInterface,
        playTime: @escaping (String, CMTime) -> Void
    ) {
        self.viewModel = viewModel
        self.playTime = playTime
    }
    
    func makeUIView(context: Context) -> VideoPlayView {
        return VideoPlayView(viewModel: viewModel, playTime: playTime)
    }
    
    func updateUIView(_ uiView: VideoPlayView, context: Context) {
        
    }
}
