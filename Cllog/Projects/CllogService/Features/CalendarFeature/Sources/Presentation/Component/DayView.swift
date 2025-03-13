//
//  DayView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit
import CalendarDomain

struct DayView: View {
    private let day: ClimbDay
    private let onTapped: () -> Void
    
    init(
        day: ClimbDay,
        onTapped: @escaping () -> Void
    ) {
        self.day = day
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button {
            onTapped()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        day.isCurrentMonth ?
                        Color.clLogUI.gray700 : .clear
                    )
                
                AsyncImage(url: URL(string: day.thumbnail ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(43/53, contentMode: .fill)
                            .overlay {
                                Color.black.opacity(0.3)
                            }
                    } else {
                        Color.clear
                    }
                }
                
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .font(.h5)
                    .foregroundStyle(
                        day.isCurrentMonth ?
                        Color.clLogUI.white : Color.clLogUI.gray600
                    )
                
            }
            .aspectRatio(43/53, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

#Preview {
    DayView(
        day: ClimbDay(date: Date(), thumbnail: "", stories: [], isCurrentMonth: true),
        onTapped: { }
    )
}
