//
//  ClLogUI.swift
//  ClLogUI
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public struct ClLogUI<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ClLogUISupporttable {
    
    associatedtype Base
    
    static var clLogUI: ClLogUI<Base>.Type { get set }
    var clLogUI: ClLogUI<Base> { get set }
}

extension ClLogUISupporttable {
    
    public var clLogUI: ClLogUI<Self> {
        get { ClLogUI(self) }
        set { }
    }
    
    public static var clLogUI: ClLogUI<Self>.Type {
        get { ClLogUI<Self>.self }
        set {}
    }
}

extension UIColor: ClLogUISupporttable {}
extension Color: ClLogUISupporttable {}
extension Image: ClLogUISupporttable {}
