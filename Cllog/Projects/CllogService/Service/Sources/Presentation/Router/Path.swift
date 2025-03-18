//
//  Path.swift
//  CllogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CalendarFeature

@Reducer
public enum Path {
    case calendarDetail(CalendarDetailFeature)
}
