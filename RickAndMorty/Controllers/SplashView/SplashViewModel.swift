//
//  SplashViewModel.swift
//  RickAndMorty
//
//  Created by Lex Sava on 28.12.2023.
//

import Combine
import SwiftUI

@MainActor
final class SplashViewModel<Coordinator: Routing>: ObservableObject {
    var coordinator: Coordinator?
    var services: ServicesContainerProtocol? {
        return coordinator?.servicesContainer
    }
    
    init() {
//        print(#line, #function)
    }
    
    func showNextRoute() {
        Task {
            try await Task.sleep(nanoseconds: 1 * 1_000_000)
            self.coordinator?.handle(action: SplashFlow.main)
        }
    }
    
}
