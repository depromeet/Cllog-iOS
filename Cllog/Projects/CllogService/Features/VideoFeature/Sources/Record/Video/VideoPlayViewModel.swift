//
//  UIViewoPlayViewModel.swift
//  VideoFeature
//
//  Created by saeng lin on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation
import Combine

public protocol VideoPlayViewModelOutputInterface {
    var playerConfigurePublisher: AnyPublisher<URL, Never> { get }
    var playerTimePublisher: AnyPublisher<(String, CMTime), Never> { get }
    var playerReplayPublisher: AnyPublisher<Void, Never> { get }
    var playerSeekingPublisher: AnyPublisher<CMTime, Never> { get }
}

public protocol VideoPlayViewModelInputInterface {
    func onInitialize()
    func onPlayerTime(for time: CMTime)
    func onPlayerDidFinish()
}

public protocol VideoPlayViewModelInterface: ObservableObject {
    var input: VideoPlayViewModelInputInterface { get }
    var output: VideoPlayViewModelOutputInterface { get }
}

final public class VideoPlayViewModel: VideoPlayViewModelInterface {
    
    public var input: VideoPlayViewModelInputInterface { self }
    public var output: VideoPlayViewModelOutputInterface { self }
    
    private let playerConfigureSubject = PassthroughSubject<URL, Never>()
    private let playerTimeSubject = PassthroughSubject<(String, CMTime), Never>()
    private let playerReplaySubject = PassthroughSubject<Void, Never>()
    private let playerSeekingSubject = PassthroughSubject<CMTime, Never>()
    
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
}

extension VideoPlayViewModel: VideoPlayViewModelInputInterface {
    public func onInitialize() {
        playerConfigureSubject.send(fileURL)
    }
    
    public func onPlayerTime(for time: CMTime) {
        let totalSeconds = Int(CMTimeGetSeconds(time))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60

        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        playerTimeSubject.send((formattedTime, time))
    }
    
    public func onPlayerDidFinish() {
        playerReplaySubject.send(())
    }
}

extension VideoPlayViewModel: VideoPlayViewModelOutputInterface {
    public var playerConfigurePublisher: AnyPublisher<URL, Never> {
        return playerConfigureSubject.eraseToAnyPublisher()
    }
    
    public var playerTimePublisher: AnyPublisher<(String, CMTime), Never> {
        return playerTimeSubject.eraseToAnyPublisher()
    }
    
    public var playerReplayPublisher: AnyPublisher<Void, Never> {
        return playerReplaySubject.eraseToAnyPublisher()
    }
    
    public var playerSeekingPublisher: AnyPublisher<CMTime, Never> {
        return playerSeekingSubject.eraseToAnyPublisher()
    }
}
