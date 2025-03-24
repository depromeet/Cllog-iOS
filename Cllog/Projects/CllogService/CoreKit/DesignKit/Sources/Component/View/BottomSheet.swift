//
//  BottomSheet.swift
//  DesignKit
//
//  Created by Junyoung on 3/4/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public extension View {
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                sheetContent: content
            )
        )
    }
}

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .sheet(isPresented: $isPresented) {
                    BottomSheetView(
                        content: sheetContent
                    )
                }.zIndex(.zero)
        }
    }
}

struct BottomSheetView<SheetContent: View>: View {
    @State var dynamicHeight: CGFloat
    let content: () -> SheetContent
    
    init(
        dynamicHeight: CGFloat = 0,
        content: @escaping () -> SheetContent
    ) {
        self.dynamicHeight = dynamicHeight
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Capsule()
                .fill(Color.clLogUI.gray500)
                .frame(width: 36, height: 6)
                .padding(.vertical, 5)
            
            ScrollView {
                content()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    DispatchQueue.main.async {
                                        dynamicHeight += geometry.size.height
                                    }
                                }
                        }
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .presentationBackground(Color.clLogUI.gray800)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        DispatchQueue.main.async {
                            dynamicHeight += geometry.size.height
                        }
                    }
            }
        )
        .presentationDetents([.height(dynamicHeight)])
    }
}

// MARK: Preview
struct ContainerBottomSheetView: View {
    @State private var isPresent: Bool
    
    init(isPresent: Bool = false) {
        self.isPresent = isPresent
    }
    
    var body: some View {
        Button {
            isPresent = true
        } label: {
            Text("bottom Sheet")
        }
        .bottomSheet(isPresented: $isPresent) {
            VStack(alignment: .leading) {
                Text("클라이밍파크 강남점")
                    .foregroundStyle(Color.clLogUI.white)
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clLogUI.gray700)
                        .frame(height: 74)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    ContainerBottomSheetView()
}
