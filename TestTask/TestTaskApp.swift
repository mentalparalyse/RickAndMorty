//
//  TestTaskApp.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

@main
struct TestTaskApp: App {
    
    let networkService = NetworkService()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(networkService))
        }
    }
}
