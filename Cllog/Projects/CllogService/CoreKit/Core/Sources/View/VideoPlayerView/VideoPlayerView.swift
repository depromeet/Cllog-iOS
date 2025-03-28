//
//  VideoPlayerView.swift
//  Core
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVKit

public struct VideoPlayerView: UIViewRepresentable {
    private let player: AVPlayer
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    
    public init(
        player: AVPlayer,
        isPlaying: Binding<Bool>,
        currentProgress: Binding<Double>
    ) {
        self.player = player
        self._playbackState = isPlaying
        self._playbackProgress = currentProgress
    }
    
    public func makeUIView(context: Context) -> UIView {
        VideoPlayerContainer(
            player: player,
            isPlaying: $playbackState,
            progress: $playbackProgress
        )
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        if playbackState {
            if player.timeControlStatus != .playing {
                player.play()
            }
        } else {
            if player.timeControlStatus != .paused {
                player.pause()
            }
        }
    }
}

final class VideoPlayerContainer: UIView {
    private let mediaPlayer: AVPlayer
    private var playerDisplayLayer: AVPlayerLayer?
    private var playbackTimeObserver: Any?
    
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    
    init(
        player: AVPlayer,
        isPlaying: Binding<Bool>,
        progress: Binding<Double>
    ) {
        self.mediaPlayer = player
        self._playbackState = isPlaying
        self._playbackProgress = progress
        super.init(frame: .zero)
        setupPlayerLayer()
        configurePlaybackObserver()
    }
    
    private func setupPlayerLayer() {
        playerDisplayLayer = AVPlayerLayer(player: mediaPlayer)
        guard let playerLayer = playerDisplayLayer else { return }
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerDisplayLayer?.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("Initialization with coder is not supported")
    }
    
    private func configurePlaybackObserver() {
        playbackTimeObserver = mediaPlayer.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: .main
        ) { [weak self] currentTime in
            guard let self = self else { return }
            
            let totalDuration = self.mediaPlayer.currentItem?.duration.seconds ?? 1
            if totalDuration > 0 {
                self.playbackProgress = currentTime.seconds / totalDuration
            }
        }
    }
}
