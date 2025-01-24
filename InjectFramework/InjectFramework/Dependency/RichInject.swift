//
//  RichInject.swift
//  InjectFramework
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

public protocol RichDependencyInjectable: Sendable {
    func register<T>(_ type: T.Type, closure: @Sendable (RichDependencyInjectable) -> T)
    func resolve<T>(_ objectType: T.Type) -> T
}

final public class RichDependencyInject: @unchecked Sendable, RichDependencyInjectable {
    
    private var objectMap: [ObjectIdentifier: AnyObject] = [:]

    public func register<T>(_ type: T.Type, closure: @Sendable (any RichDependencyInjectable) -> T) {
        let key = ObjectIdentifier(type)
        guard objectMap[key] == nil else {
            return
        }
        self.objectMap[key] = closure(self) as AnyObject
    }
    
    public func resolve<T>(_ anyClassType: T.Type) -> T {
        let key = ObjectIdentifier(anyClassType)
        guard let object = objectMap[key] as? T else {
            fatalError()
        }
        return object
    }
    
}
