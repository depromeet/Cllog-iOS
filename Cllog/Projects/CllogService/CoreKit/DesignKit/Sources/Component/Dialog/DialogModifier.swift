//
//  DialogModifier.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// MARK: - Modifier
struct DialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    var model: DialogModel
    
    private static var currentAlertController: UIHostingController<DialogView>?
    
    init(isPresented: Binding<Bool>, model: DialogModel) {
        self._isPresented = isPresented
        self.model = model
    }
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    showDialog()
                } else {
                    dismissDialog()
                }
            }
            .onAppear {
                if isPresented {
                    showDialog()
                }
            }
    }
    
    private func showDialog() {
        guard let topVC = getTopMostViewController() else { return }
        
        if DialogModifier.currentAlertController != nil {
            return
        }
        
        let view = DialogView(isPresented: $isPresented, model: model)
        let alertController = UIHostingController(rootView: view)
        alertController.view.backgroundColor = .clear
        alertController.modalPresentationStyle = .overFullScreen
        
        DialogModifier.currentAlertController = alertController
        
        topVC.present(alertController, animated: false)
    }
    
    private func dismissDialog() {
        if let alertController = DialogModifier.currentAlertController {
            alertController.dismiss(animated: false) {
                DialogModifier.currentAlertController = nil
            }
        }
    }
    
    private func getTopMostViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        
        return findTopMostViewController(rootVC)
    }
    
    private func findTopMostViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedVC = viewController.presentedViewController {
            return findTopMostViewController(presentedVC)
        } else if let navigationController = viewController as? UINavigationController,
                  let visibleVC = navigationController.visibleViewController {
            return findTopMostViewController(visibleVC)
        } else if let tabBarController = viewController as? UITabBarController,
                  let selectedVC = tabBarController.selectedViewController {
            return findTopMostViewController(selectedVC)
        } else {
            return viewController
        }
    }
}
