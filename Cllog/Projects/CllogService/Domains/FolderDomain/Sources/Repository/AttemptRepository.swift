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
}

// TODO: Remove
public struct MockAttemptRepository: AttemptRepository {
    public init() {}
    
    public func getFilteredAttempts() async throws -> [Attempt] {
        [
            Attempt(
                date: "2024-03-13",
                grade: Grade(name: "V5", hexCode: "0xFF5733"),
                result: .complete,
                recordedTime: "00:45",
                crag: Crag(name: "Seoul Bouldering", address: "Seoul, South Korea")
            ),
            Attempt(
                date: "2024-03-12",
                grade: Grade(name: "V7", hexCode: "0x33FF57"),
                result: .fail,
                recordedTime: "01:30",
                crag: Crag(name: "Incheon Rock Gym", address: "Incheon, South Korea")
            ),
            Attempt(
                date: "2024-03-11",
                grade: Grade(name: "V4", hexCode: "0x3357FF"),
                result: .complete,
                recordedTime: "00:50",
                crag: Crag(name: "Busan Climbing", address: "Busan, South Korea")
            ),
            Attempt(
                date: "2024-03-10",
                grade: Grade(name: "V6", hexCode: "0xF1C40F"),
                result: .fail,
                recordedTime: "01:10",
                crag: nil
            ),
            Attempt(
                date: "2024-03-09",
                grade: nil,
                result: .complete,
                recordedTime: "00:40",
                crag: Crag(name: "Daegu Rock Gym", address: "Daegu, South Korea")
            )
        ]
    }
}
