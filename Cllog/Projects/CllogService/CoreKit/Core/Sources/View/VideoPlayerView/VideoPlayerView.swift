//
//  VideoPlayerView.swift
//  Core
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import AVKit
import Photos

public struct VideoPlayerView: UIViewRepresentable {
    private let playerManager: VideoPlayerManager
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    
    public init(
        videoPath: URL,
        isPlaying: Binding<Bool>,
        currentProgress: Binding<Double>
    ) {
        self.playerManager = VideoPlayerManager(url: videoPath)
        self._playbackState = isPlaying
        self._playbackProgress = currentProgress
    }
    
    public init(
        assetID: String,
        isPlaying: Binding<Bool>,
        currentProgress: Binding<Double>
    ) {
        self.playerManager = VideoPlayerManager(assetID: assetID)
        self._playbackState = isPlaying
        self._playbackProgress = currentProgress
    }
    
    public func makeUIView(context: Context) -> UIView {
        VideoPlayerContainer(
            player: playerManager.player,
            isPlaying: $playbackState,
            progress: $playbackProgress
        )
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        guard let container = uiView as? VideoPlayerContainer else { return }
        
        if playbackState {
            if container.player.timeControlStatus != .playing {
                container.player.play()
            }
        } else {
            if container.player.timeControlStatus != .paused {
                container.player.pause()
            }
        }
    }
}

final class VideoPlayerContainer: UIView {
    let player: AVPlayer
    private var playerDisplayLayer: AVPlayerLayer?
    private var playbackTimeObserver: Any?
    private var playerItemObserver: NSObjectProtocol?
    
    @Binding private var playbackState: Bool
    @Binding private var playbackProgress: Double
    
    init(
        player: AVPlayer,
        isPlaying: Binding<Bool>,
        progress: Binding<Double>
    ) {
        self.player = player
        self._playbackState = isPlaying
        self._playbackProgress = progress
        super.init(frame: .zero)
        setupPlayerLayer()
        configurePlaybackObserver()
    }
    
    private func setupPlayerLayer() {
        playerDisplayLayer = AVPlayerLayer(player: player)
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
        playbackTimeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] currentTime in
            guard let self = self else { return }
            
            let totalDuration = self.player.currentItem?.duration.seconds ?? 1
            if totalDuration > 0 {
                self.playbackProgress = currentTime.seconds / totalDuration
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    @objc private func videoDidEnd() {
       player.seek(to: .zero)
        player.pause()
        playbackProgress = 0
        playbackState = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        playerItemObserver = nil
        playbackTimeObserver = nil
    }
}

class VideoPlayerManager {
    let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    init(assetID: String) {
        // 임시 플레이어 생성
        self.player = AVPlayer(url: URL(string: "about:blank")!)
        
        // PHAsset에서 비디오 로드
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
        
        if let asset = fetchResult.firstObject {
            let options = PHVideoRequestOptions()
            options.version = .original
            options.deliveryMode = .highQualityFormat
            
            PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { [weak self] asset, _, _ in
                DispatchQueue.main.async {
                    if let urlAsset = asset as? AVURLAsset, let self = self {
                        self.player.replaceCurrentItem(with: AVPlayerItem(url: urlAsset.url))
                    }
                }
            }
        }
    }
}
