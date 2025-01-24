//
//  ViewModel.swift
//  Account
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

import AccountPresentation

public struct Account {
    
    private let viewmodel: AccountViewModelable
    
    public init(
        viewModel: AccountViewModelable = AccountViewModel()
    ) {
        self.viewmodel = viewModel
    }
    
    public func start() async throws {
        
    }
}

