//
//  DialogView.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// MARK: - Model
public struct Dialog: Equatable {
    public static func == (lhs: Dialog, rhs: Dialog) -> Bool {
        return lhs.title == rhs.title &&
        lhs.subTitle == rhs.subTitle &&
        lhs.confirmText == rhs.confirmText &&
        lhs.cancelText == rhs.cancelText &&
        lhs.style == rhs.style
    }
    
    let title: String
    let subTitle: String
    let confirmText: String
    let cancelText: String
    let style: DialogStyle
    
    let confirmTapped: () -> Void
    let cancelTapped: () -> Void
    
    public init(
        title: String,
        subTitle: String,
        confirmText: String,
        cancelText: String,
        style: DialogStyle = .default,
        confirmTapped: @escaping () -> Void,
        cancelTapped: @escaping () -> Void
    ) {
        self.title = title
        self.subTitle = subTitle
        self.confirmText = confirmText
        self.cancelText = cancelText
        self.style = style
        self.confirmTapped = confirmTapped
        self.cancelTapped = cancelTapped
    }
}

public enum DialogStyle {
    case `default`
    case delete
    
    var button: GeneralButtonStyle {
        switch self {
        case .default:
            return .white
        case .delete:
            return .error
        }
    }
}

// MARK: - Modifier
struct DialogModifier: ViewModifier {
    @Binding var dialog: Dialog?
    @State private var isDialogVisible = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let dialog {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        closeDialog()
                    }
                
                makeDialogView(dialog)
                    .padding(.horizontal, 24)
                    .scaleEffect(isDialogVisible ? 1 : 0.8)
                    .opacity(isDialogVisible ? 1 : 0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isDialogVisible)
                    .transition(.opacity.combined(with: .scale))
                    .onAppear {
                        showDialog()
                    }
            }
        }
    }
    
    private func makeDialogView(_ dialog: Dialog) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 14) {
                Text(dialog.title)
                    .font(.h2)
                    .foregroundStyle(Color.clLogUI.white)
                    .frame(alignment: .center)
                Text(dialog.subTitle)
                    .font(.b1)
                    .foregroundStyle(Color.clLogUI.gray300)
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: 10) {
                GeneralButton(dialog.cancelText) {
                    dialog.cancelTapped()
                    closeDialog()
                }
                .style(.normal)
                
                GeneralButton(dialog.confirmText) {
                    dialog.confirmTapped()
                    closeDialog()
                }
                .style(dialog.style.button)
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(Color.clLogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func showDialog() {
        withAnimation {
            isDialogVisible = true
        }
    }
    
    private func closeDialog() {
        withAnimation {
            isDialogVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if !isDialogVisible {
                dialog = nil
            }
        }
    }
}

// MARK: - View Extension
public extension View {
    func presentDialog(_ dialog: Binding<Dialog?>) -> some View {
        self.modifier(
            DialogModifier(dialog: dialog)
        )
    }
}

// MARK: - Preview
struct ContainerDialogView : View {
    @State var dialog: Dialog? = nil

    var body: some View {
        Button {
            dialog = Dialog(
                title: "안녕하세요",
                subTitle: "부제목입니다.길어요오오오오오오오오오오오ㅗ옹ㅇ랴더랴더랴더랴",
                confirmText: "확인",
                cancelText: "취소",
                style: .delete
            ) {
                    print("확인")
                } cancelTapped: {
                    print("취소")
                }
        } label: {
            Text("show dialog")
        }
        .presentDialog($dialog)
    }
}


#Preview {
    ContainerDialogView()
}
