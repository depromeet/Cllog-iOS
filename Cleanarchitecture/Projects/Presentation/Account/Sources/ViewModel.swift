//
//  ViewModel.swift
//  AccountPresentation
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

public protocol AccountViewModelable {
    func onAppear() async
}

public class AccountViewModel: AccountViewModelable {
    
    public init() {}
    
    public func onAppear() async {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        print("account")
    }
}
