//
//  SplashCoordinator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 28.12.2023.
//

import SwiftUI

enum SplashFlow: CoordinatorAction {
    case main
}

enum SplashRouting: NavigationRoute {
    case splash, main
    
    var appearance: RouteAppearance? {
        nil
    }
    var title: String? {
        nil
    }
    var transitionAction: TransitionAction? {
        .push(animated: true)
    }
    
    var attachCoordinator: Bool {
        true
    }
}

final class SplashCoordinator: Routing {
    
    
    weak var parent: CoordinatorProtocol?
    var id: UUID
    var childs = [WeakCoordinator]()
    let navigationController: NavigationController
    let startRoute: SplashRouting
    let factory: CoordinatorFactoryProtocol
    var servicesContainer: ServicesContainerProtocol

    init(parent: CoordinatorProtocol? = nil,
         navigationController: NavigationController,
         startRoute: SplashRouting = .splash,
         factory: CoordinatorFactoryProtocol,
         services: ServicesContainerProtocol) {
        self.parent = parent
        self.navigationController = navigationController
        self.startRoute = startRoute
        self.factory = factory
        self.servicesContainer = services
        self.id = UUID()
    }
    
    func handle(action: CoordinatorAction) {
        switch action {
        case SplashFlow.main:
            let coordinator = factory.makeDataListCoordinator(self)
            try? coordinator.start()
        default:
            parent?.handle(action: action)
        }
    }
}

extension SplashCoordinator: RouterViewFactory {
    @ViewBuilder
    func view(for route: SplashRouting) -> some View {
        switch route {
        case .splash:
            SplashView<SplashCoordinator>()
        case .main:
            ContentView<DataListCoordinator>()
        }
    }
}
