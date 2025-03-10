//
//  AppBar.swift
//  DesignKit
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct AppBar<LeftContent: View, RightContent: View>: View {
    
    let leftContent: LeftContent
    let rightContent: RightContent
    
    public init(
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            leftContent
            Spacer()
            rightContent
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(Color.clLogUI.gray800)
    }
}

#Preview {
    AppBar {
        
    } rightContent: {
        
    }

}
