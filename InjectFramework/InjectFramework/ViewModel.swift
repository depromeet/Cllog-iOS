//
//  ViewModel.swift
//  InjectFramework
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

class ViewModel {
    
    private let dependency: ViewModelDependencyable
    
    init(dependency: ViewModelDependencyable = RichDependencyInject.home.resolve(ViewModelDependencyable.self)) {
        self.dependency = dependency
    }
}

protocol ViewModelDependencyable {}

struct ViewModelDependency: ViewModelDependencyable {}
