//
//  FolderAttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct FolderAttemptResponseDTO: Decodable {
    let attemptId: Int
    let date: String
    let video: FolderVideoResponseDTO
    let cragName: String?
    let colorName: String?
    let colorHex: String?
    let status: String
    
    func toDomain() -> Attempt {
        Attempt(
            date: date,
            grade: colorName.flatMap { name in
                colorHex.map { hex in Grade(name: name, hexCode: hex) }
            },
            result: AttemptResult(rawValue: status) ?? .complete,
            recordedTime: video.durationMS.msToTimeString,
            crag: cragName.flatMap { cragName in
                Crag(name: cragName, address: "")
            }
        )
    }
}
