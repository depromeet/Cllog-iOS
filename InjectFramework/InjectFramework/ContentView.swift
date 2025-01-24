//
//  ContentView.swift
//  InjectFramework
//
//  Created by saeng lin on 1/24/25.
//

import SwiftUI

struct ContentView: View {
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel = ViewModel()) {
        RichDependencyInject.home.register(ViewModelDependencyable.self) { _ in
            return ViewModelDependency()
        }
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
