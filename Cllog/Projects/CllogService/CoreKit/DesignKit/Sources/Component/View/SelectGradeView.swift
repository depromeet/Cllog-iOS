//
//  SelectGradeView.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct DesignGrade: Hashable, Identifiable {
    public var id: UUID
    
    public init(name: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.color = color
    }
    
    public let name: String
    public let color: Color
}

public struct SelectGradeView: View {
    
    public init(
        cragName: String,
        grades: [DesignGrade],
        selectedGrade: Binding<DesignGrade?>,
        selectedUnSaveGrade: Binding<Bool>,
        didTapSaveButton: @escaping () -> Void,
        didTapCragTitleButton: @escaping() -> Void
    ) {
        self.cragName = cragName
        self.grades = grades
        self._selectedGrade = selectedGrade
        self._selectedUnSaveGrade = selectedUnSaveGrade
        self.didTapSaveButton = didTapSaveButton
        self.didTapCragTitleButton = didTapCragTitleButton
    }
    
    private let cragName: String
    private let grades: [DesignGrade]
    @Binding private var selectedGrade: DesignGrade?
    @Binding private var selectedUnSaveGrade: Bool
    private var didTapSaveButton: () -> Void
    private var didTapCragTitleButton: () -> Void
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            Button {
                print("tapped")
            } label: {
                Text(cragName)
                    .font(.b1)
                    .foregroundStyle(Color.clLogUI.gray50)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.clLogUI.gray900)
            .cornerRadius(12)
            
            Text("문제 난이도")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
                .padding(.top, 16)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: 36), spacing: 28)]) {
                ForEach(grades, id: \.self) { grade in
                    Circle()
                        .foregroundStyle(grade.color)
                        .overlay(
                            Circle()
                                .strokeBorder(
                                    selectedGrade == grade ? Color.clLogUI.white : Color.clear,
                                    lineWidth: 3
                                )
                        )
                        .onTapGesture {
                            selectedGrade = grade
                        }
                }
            }
            .padding(.vertical, 16)
            .background(Color.clLogUI.gray900)
            .cornerRadius(12)
            
            CheckBoxButton(
                title: "난이도 미등록",
                isActive: $selectedUnSaveGrade
            )
            .padding(.top, 10)
            .padding(.bottom, 40)
            
            GeneralButton("저장하기") {
                print("저장")
            }
            .style(.white)
        }
        .background(Color.clLogUI.gray800)
    }
}

struct SelectGradeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGradeView(
            cragName: "한남 암장",
            grades: [
                DesignGrade(name: "V1", color: .blue),
                DesignGrade(name: "V2", color: .green),
                DesignGrade(name: "V3", color: .red),
            ],
            selectedGrade: .constant(nil),
            selectedUnSaveGrade: .constant(false),
            didTapSaveButton: {
                
            },
            didTapCragTitleButton: {
                
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
