//
//  LoginView.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import UIKit
import DesignKit
import AuthenticationServices

import ComposableArchitecture

public struct LoginView: View {
    
    private let store: StoreOf<LoginFeature>
    private weak var on: UIViewController?
    
    public init(
        on: UIViewController?,
        store: StoreOf<LoginFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.black
            
            VStack {
                Image.clLogUI.clogLogo
                
                Spacer()
                    .frame(height: 20)
                
                Text("영상으로 남기는\n클라이밍 기록 서비스")
                    .foregroundColor(Color.green)
                
                Spacer()
                
                // TODO: 필요에 따라 LoginView로 변경
                // MARK: Kakao Login Button
                Button {
                    store.send(.kakaoLoginButtonTapped)
                } label: {
                    HStack(spacing: 16) {
                        Image.clLogUI.kakaoLogo
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        // TODO: Design Kit 적용
                        Text("카카오로 계속하기")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.brown) // TODO: Design System Color
                            .padding(16)
                    }
                    .font(.title2)
                    .padding(.horizontal, 16)
                    .foregroundColor(Color.yellow) // TODO: Design System
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow)
                    )
                }
                
                // TODO: 카카오 및 애플 디자인 통일
                SignInWithAppleButton { request in
                    
                } onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        let credential = authorization.credential as? ASAuthorizationAppleIDCredential
                        let authorizationCode = String(data: credential?.authorizationCode ?? Data(), encoding: .utf8)
                        store.send(.appleLoginCompleted(authorizationCode: authorizationCode))
                        
                    case .failure(let error):
                        store.send(.failLogin)
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 56)
                
                Spacer()
                    .frame(height: 42)
                
                Text("가입하면 테스트앱의\n[이용약관](https://www.naver.com) 및 [개인정보 처리방침](https://www.daum.net)에 동의하게 됩니다.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .font(.system(size: 14)) // TODO: Design System 적용
            }
            .padding(16)
        }
        .ignoresSafeArea()
    }
}
