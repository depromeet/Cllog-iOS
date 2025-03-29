//
//  UserInfoFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

import CalendarDomain
import StoryDomain

@Reducer
public struct UserInfoFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isOpen: Bool = false
        var isEditMemo : Bool = false
        var currentMonth: Int = 0
        
        var numOfClimbDays: Int = 0
        var id: Int = 0
        var cragName: String = ""
        var totalDurationMs: Int = 0
        var totalAttemptsCount: Int = 0
        var totalSuccessCount: Int = 0
        var totalFailCount: Int = 0
        var memo: String = ""
        var editMemo: String = ""
        var problems: [StorySummaryProblem] = []
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateCurrentMonth(Int)
        case updateCalendarInfo(CalendarSummary)
        case updateStoryInfo(StorySummary)
        case updateMemo(String)
        case editMemo(Bool)
        case dropdownTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .dropdownTapped:
                state.isOpen.toggle()
                return .none
            case let .updateCalendarInfo(summary):
                state.numOfClimbDays = summary.numOfClimbDays
                state.totalDurationMs = summary.totalDurationMs
                state.totalAttemptsCount = summary.totalAttemptCount
                state.totalSuccessCount = summary.successAttemptCount
                state.totalFailCount = summary.failAttemptCount
                return .none
            case let .updateStoryInfo(summary):
                state.id = summary.id
                state.cragName = summary.cragName ?? "암장 정보 미등록"
                state.totalDurationMs = summary.totalDurationMs
                state.totalAttemptsCount = summary.totalAttemptsCount
                state.totalSuccessCount = summary.totalSuccessCount
                state.totalFailCount = summary.totalFailCount
                state.memo = summary.memo ?? ""
                state.problems = summary.problems
                
                return .none
            case let .updateCurrentMonth(month):
                state.currentMonth = month
                return .none
                
            case let .editMemo(isEdit):
                state.isEditMemo = isEdit
                if isEdit {
                    state.editMemo = state.memo
                }
                return .none
                
            case let .updateMemo(text):
                state.memo = text
                return .none
                
            default:
                return .none
            }
        }
    }
}
