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
        didTapSaveButton: @escaping (DesignGrade?) -> Void,
        didTapCragTitleButton: @escaping() -> Void
    ) {
        self.cragName = cragName
        self.grades = grades
        self.didTapSaveButton = didTapSaveButton
        self.didTapCragTitleButton = didTapCragTitleButton
    }
    
    private let cragName: String
    private let grades: [DesignGrade]
    private var didTapSaveButton: (DesignGrade?) -> Void
    private var didTapCragTitleButton: () -> Void
    
    @State private var selectedGrade: DesignGrade?
    @State private var selectedUnSaveGrade: Bool = false
    
    public var body: some View {
        VStack(alignment: .leading) {
            cragTitleSection
            gradeSelectionSection
            checkboxSection
            saveButtonSection
        }
        .background(Color.clLogUI.gray800)
        .onChange(of: selectedGrade) { _, newValue in
            if selectedUnSaveGrade, newValue != nil {
                selectedUnSaveGrade = false
            }
        }
        .onChange(of: selectedUnSaveGrade) { _, newValue in
            if newValue, selectedGrade != nil {
                selectedGrade = nil
            }
        }
    }
    
    // MARK: - UI Components
    private var cragTitleSection: some View {
        VStack(alignment: .leading) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            Button {
                didTapCragTitleButton()
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
        }
    }
    
    private var gradeSelectionSection: some View {
        VStack(alignment: .leading) {
            Text("문제 난이도")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
                .padding(.top, 16)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: 36), spacing: 28)]) {
                ForEach(grades, id: \.self) { grade in
                    gradeGradeChip(for: grade)
                }
            }
            .padding(.vertical, 16)
            .background(Color.clLogUI.gray900)
            .cornerRadius(12)
        }
    }
    
    private func gradeGradeChip(for grade: DesignGrade) -> some View {
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
    
    private var checkboxSection: some View {
        CheckBoxButton(
            title: "난이도 미등록",
            isActive: $selectedUnSaveGrade
        )
        .padding(.top, 10)
        .padding(.bottom, 40)
    }
    
    private var saveButtonSection: some View {
        GeneralButton("저장하기") {
            didTapSaveButton(selectedGrade)
        }
        .style(.white)
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
            didTapSaveButton: { _ in
                
            },
            didTapCragTitleButton: {
                
            }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
