//
//  ThumbnailView.swift
//  DesignKit
//
//  Created by soi on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum ThumbnailType {
    case `default`(cragName: String, date: String)
    case calendar
}

public struct ThumbnailView: View {
    private let imageURLString: String
    private let thumbnailType: ThumbnailType
    private let challengeResult: ChallengeResult
    private let level: Level
    private let time: String
    private let deleteButtonHandler: (() -> Void)?
    
    public init(
        imageURLString: String,
        thumbnailType: ThumbnailType,
        challengeResult: ChallengeResult,
        level: Level,
        time: String,
        deleteButtonHandler: (() -> Void)? = nil
    ) {
        self.imageURLString = imageURLString // FIXME: response 확인
        self.thumbnailType = thumbnailType
        self.challengeResult = challengeResult
        self.level = level
        self.time = time
        self.deleteButtonHandler = deleteButtonHandler
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MARK: Time Chip
            ZStack(alignment: .topTrailing) {
                
                // MARK: Chips
                ZStack(alignment: .bottomLeading) {
                    
                    // MARK: Image View
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.clLogUI.gray600)
                        
                        AsyncImage(url: URL(string: imageURLString)) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                                    .scaledToFit()
                            default:
                                Image(systemName: "photo")
                                    .foregroundColor(.clLogUI.gray600)
                            }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    
                    HStack(spacing: 5) {
                        CompleteOrFailChip(
                            challengeResult: challengeResult,
                            isActive: true
                        )
                        
                        LevelChip(level: level)
                            .opacity(0.7)
                    }
                    .padding([.leading, .bottom], 8)
                }
                
                ThumbnailTimeChip(time)
                    .padding([.trailing, .top], 8)
                
                if let deleteButtonHandler {
                    Button {
                        deleteButtonHandler()
                    } label: {
                        Image("x", bundle: .module)
                    }
                    .padding(-6)
                    .alignmentGuide(.top) { _ in 0 }
                }
            }
            
            if case let .default(cragName, date) = thumbnailType {
                Spacer()
                    .frame(height: 8)
                
                Text(date)
                    .font(.b1)
                    .foregroundStyle(Color.clLogUI.white)
                
                Text(cragName)
                    .font(.b2)
                    .foregroundStyle(Color.clLogUI.gray400)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ThumbnailTimeChip: View {
    private let time: String
    
    init(_ time: String) {
        self.time = time
    }
    
    var body: some View {
        Text(time)
            .font(.c1)
            .foregroundStyle(Color.clLogUI.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.clLogUI.gray700.opacity(0.7))
            )
    }
}

#Preview {
    Group {
        ThumbnailView(
            imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
            thumbnailType: .default(
                cragName: "클라이밍파크 강남점",
                date: "25.02.08 FRI"
            ),
            challengeResult: .complete,
            level: .blue,
            time: "00:00:00"
        )
        
        ThumbnailView(
            imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
            thumbnailType: .calendar,
            challengeResult: .complete,
            level: .blue,
            time: "00:00:00"
        )
        
        ThumbnailView(
            imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
            thumbnailType: .calendar,
            challengeResult: .complete,
            level: .blue,
            time: "00:00:00",
            deleteButtonHandler: {
                print("delete button tapped")
            }
        )
        
        ThumbnailView(
            imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
            thumbnailType: .default(
                cragName: "클라이밍파크 강남점",
                date: "25.02.08 FRI"
            ),
            challengeResult: .complete,
            level: .blue,
            time: "00:00:00",
            deleteButtonHandler: {
                print("delete button tapped")
            }
        )
    }
    .background(
        Color.clLogUI.gray900
    )
}
