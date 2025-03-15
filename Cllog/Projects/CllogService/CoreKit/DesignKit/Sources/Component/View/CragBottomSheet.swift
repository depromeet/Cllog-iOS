//
//  CragBottomSheet.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Combine

public struct DesignCrag: Hashable, Identifiable {
    public var id: UUID
    
    public init(name: String, address: String) {
        self.id = UUID()
        self.name = name
        self.address = address
    }
    
    public let name: String
    public let address: String
}

struct SelectCragView: View {
    
    public init(
        didTapSaveButton: @escaping (DesignCrag) -> Void,
        didTapSkipButton: @escaping () -> Void,
        didChangeSearchText: @escaping (String) -> Void,
        crags: Binding<[DesignCrag]>
    ) {
        self.didTapSaveButton = didTapSaveButton
        self.didTapSkipButton = didTapSkipButton
        self.didChangeSearchText = didChangeSearchText
        self._crags = crags
    }
    
    private var didTapSaveButton: (DesignCrag) -> Void
    private var didTapSkipButton: () -> Void
    private var didChangeSearchText: (String) -> Void
    private let searchSubject = PassthroughSubject<String, Never>()
    
    @State private var searchText = ""
    @Binding private var crags: [DesignCrag]
    @State private var selectedCrag: DesignCrag?
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack(alignment: .leading) {
            cragTitleSection
            cragSelectionSection
            buttonSection
        }
        .background(Color.clLogUI.gray800)
        .onAppear {
            searchSubject
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .sink { newValue in
                    didChangeSearchText(newValue)
                }
                .store(in: &cancellables)
        }
    }
    
    private var cragTitleSection: some View {
        VStack(alignment: .leading) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            ClLogTextInput(
                placeHolder: "암장을 입력해주세요",
                text: $searchText
            )
        }
        .onChange(of: searchText) { _, newValue in
            searchSubject.send(newValue)
        }
    }
    
    private var cragSelectionSection: some View {
        LazyVStack(alignment: .leading) {
            ForEach(crags, id: \.self) { crag in
                TwoLineRow(
                    title: crag.name,
                    subtitle: crag.address
                )
                .background(
                    selectedCrag == crag ? Color.clLogUI.gray700 : Color.clear
                )
                .onTapGesture {
                    selectedCrag = crag
                }
            }
        }
    }
    
    private var buttonSection: some View {
        HStack {
            GeneralButton("건너뛰기") {
                didTapSkipButton()
            }
            
            GeneralButton("저장하기") {
                guard let selectedCrag else { return }
                didTapSaveButton(selectedCrag)
            }
            .style(.white)
            .disabled(selectedCrag == nil)
        }
        
    }
}

struct SelectCragView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCragView(
            didTapSaveButton: { crag in
                print("저장된 암장: \(crag.name)")
            },
            didTapSkipButton: {
                print("건너뛰기 버튼 클릭됨")
            },
            didChangeSearchText: { text in
                print("검색어 변경됨: \(text)")
            },
            crags: .constant([
                DesignCrag(name: "강남점", address: "서울 강남구"),
                DesignCrag(name: "홍대점", address: "서울 마포구"),
                DesignCrag(name: "신촌점", address: "서울 서대문구")
            ])
        )
    }
}
