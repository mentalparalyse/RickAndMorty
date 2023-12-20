//
//  DependencyContainer.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import SwiftUI

@MainActor
class DependencyContainer {
    let factory = NavigationControllerFactory()
    lazy var delegate = factory.makeNavigationDelegate([])
    lazy var navigationController = factory.makeNavigationController(delegate: delegate)
    
    private(set) var appCoordinator: AppCoordinator?
    
    func set(_ coordinator: AppCoordinator) {
        guard appCoordinator == nil else { return }
        appCoordinator = coordinator
    }
}

extension DependencyContainer: CoordinatorFactoryProtocol {
    func makeDataListCoordinator(_ parent: CoordinatorProtocol, _ services: ServicesContainerProtocol) -> DataListCoordinator {
        DataListCoordinator(parent: parent,
                            navigationController: navigationController,
                            factory: self,
                            services: services)
    }
    
    func makeAppCoordinator(_ window: UIWindow) -> AppCoordinator {
        AppCoordinator(window: window,
                       navigationController: navigationController)
    }
}
