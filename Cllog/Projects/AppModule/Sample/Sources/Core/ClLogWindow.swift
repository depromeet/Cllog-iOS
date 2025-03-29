//
//  ClLogWindow.swift
//  Cllog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import CllogService
import Starlink

import Dependencies

final class ClLogWindow: UIWindow {

    @Dependency(\.loginTypeFetcherUseCase) var loginTypeFetcherUseCase

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)

        // 노티피케이션 옵저버 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDidKickOutNotification(_:)),
                                               name: .didKickOut,
                                               object: nil)

        if ClLogPhase.current == .dev {
            ConsoleWindow.shared.showOverlay()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if ClLogPhase.current == .dev, motion == .motionShake, ConsoleWindow.shared.isShowing == false {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            ConsoleWindow.shared.showOverlay()
        }
        super.motionEnded(motion, with: event)
    }

    @objc private func handleDidKickOutNotification(
        _ notification: Notification
    ) {

        if let errorMessage = notification.userInfo?["ErrorInfoMessage"] as? ErrorMessage {
            ClLogger().message(
                label: "[\(Self.self)]\(#function)",
                level: .error,
                message: "[\(Self.self)][KickOut] code: \(errorMessage.code ?? ""), message: \(errorMessage.message ?? ""), detail: \(errorMessage.detail ?? ""), name: \(errorMessage.name ?? "")"
            )
        }

        Task { @MainActor in
            await loginTypeFetcherUseCase.clear()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            let view = RouterView(store: RouterFeature.initialStore)
            windowScene.windows.first?.rootViewController = UIHostingController(rootView: view)
        }
    }
}
