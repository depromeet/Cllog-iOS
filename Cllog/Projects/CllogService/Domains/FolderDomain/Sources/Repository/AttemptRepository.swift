//
//  AttemptRepository.swift
//  FolderDomain
//
//  Created by soi on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol AttemptRepository {
    func getFilteredAttempts() async throws -> [Attempt]
    func getAttempt(attemptId: Int) async throws -> ReadAttempt
    func patchResult(attempt: ReadAttempt, result: AttemptResult) async throws
    func deleteAttempt(attemptId: Int) async throws
}

// TODO: Remove
public struct MockAttemptRepository: AttemptRepository {
    
    public init() {}
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        [
            Attempt(
                id: 0,
                date: "2024-03-13",
                grade: Grade(id: UUID().uuidString, name: "V5", hexCode: "0xFF5733"),
                result: .complete,
                recordedTime: "00:45",
                crag: Crag(name: "Seoul Bouldering", address: "Seoul, South Korea")
            ),
            Attempt(
                id: 1,
                date: "2024-03-12",
                grade: Grade(id: UUID().uuidString, name: "V7", hexCode: "0x33FF57"),
                result: .fail,
                
                recordedTime: "01:30",
                crag: Crag(name: "Incheon Rock Gym", address: "Incheon, South Korea")
            ),
            Attempt(
                id: 2,
                date: "2024-03-11",
                grade: Grade(id: UUID().uuidString, name: "V4", hexCode: "0x3357FF"),
                result: .complete,
                recordedTime: "00:50",
                crag: Crag(name: "Busan Climbing", address: "Busan, South Korea")
            ),
            Attempt(
                id: 3,
                date: "2024-03-10",
                grade: Grade(id: UUID().uuidString, name: "V6", hexCode: "0xF1C40F"),
                result: .fail,
                recordedTime: "01:10",
                crag: nil
            ),
            Attempt(
                id: 4,
                date: "2024-03-09",
                grade: nil,
                result: .complete,
                recordedTime: "00:40",
                crag: Crag(name: "Daegu Rock Gym", address: "Daegu, South Korea")
            )
        ]
    }
    
    public func getAttempt(attemptId: Int) async throws -> ReadAttempt {
        throw NSError(domain: "attempt error", code: 0)
    }
    
    public func patchResult(attempt: ReadAttempt, result: AttemptResult) async throws {
        throw NSError(domain: "attempt", code: 0)
    }
    
    public func deleteAttempt(attemptId: Int) async throws {
        throw NSError(domain: "attempt", code: 0)
    }
}
