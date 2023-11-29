//
//  RickAndMortyApp.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    let networkService = NetworkService()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(networkService))
        }
    }
}
