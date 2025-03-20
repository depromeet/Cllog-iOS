//
//  FolderAttemptCragResponseDTO.swift
//  Data
//
//  Created by soi on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

struct FolderAttemptCragResponseDTO: Decodable {
    let id: Int
    let name: String
    let roadAddress: String
    
    func toDomain() -> Crag {
        Crag(
            id: String(id),
            name: name,
            address: roadAddress
        )
    }
}

