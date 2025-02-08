//
//  DPUI.swift
//  DesignKit
//
//  Created by saeng lin on 2/9/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import UIKit
import SwiftUI

public struct DPUI<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol DPSupporttable {
    
    associatedtype DPBase
    
    static var dpUI: DPUI<DPBase>.Type { get set }
    var dpUI: DPUI<DPBase> { get set }
}

extension DPSupporttable {
    
    public var dpUI: DPUI<Self> {
        get { DPUI(self) }
        set { }
    }
    
    public static var dpUI: DPUI<Self>.Type {
        get { DPUI<Self>.self }
        set {}
    }
}

extension UIColor: DPSupporttable {}
extension Color: DPSupporttable {}
