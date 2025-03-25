//
//  GradeRepository.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol GradeRepository {
    func getGrades() async throws -> [Grade]
    func getCragGrades(cragId: Int) async throws -> [Grade]
}

// TODO: remove
public struct MockGradeRepository: GradeRepository {
    public init() {}
    
    public func getCragGrades(cragId: Int) async throws -> [Grade] {
        []
    }
    public func getGrades() async throws -> [Grade] {
        return [
            Grade(name: "핑크", hexCode: "0xFF66B2"),
            Grade(name: "레드", hexCode: "0xFF3B3F"),
            Grade(name: "주황", hexCode: "0xFF5722"),
            Grade(name: "노랑", hexCode: "0xFFEA00"),
            Grade(name: "초록", hexCode: "0x4CAF50"),
            Grade(name: "파랑", hexCode: "0x5E7CFF"),
            Grade(name: "남색", hexCode: "0x3F51B5"),
            Grade(name: "보라", hexCode: "0x9C27B0"),
            Grade(name: "갈색", hexCode: "0x795548"),
            Grade(name: "검정", hexCode: "0x000000"),
            Grade(name: "회색", hexCode: "0x9E9E9E"),
            Grade(name: "하양", hexCode: "0xFFFFFF")
        ]
    }
}
