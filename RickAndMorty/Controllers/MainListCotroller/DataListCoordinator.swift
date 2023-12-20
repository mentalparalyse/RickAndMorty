//
//  DataListCoordinator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import SwiftUI

enum ListActions: CoordinatorAction {
    case onError(NetworkError)
}

enum ListRoute: NavigationRoute {
    case main
    
    var title: String? {
        "Details"
    }
    
    var appearance: RouteAppearance? {
        .init(backgroundColor: .lightGray)
    }
    
    var transitionAction: TransitionAction? {
        .push(animated: true)
    }
}

class DataListCoordinator: Routing {
    func handle(action: CoordinatorAction) {
        switch action {
        case let ListActions.onError(error):
            print(error)
        case Action.done(_):
            popToRoot(animated: true)
            childs.removeAll()
        default: 
            parent?.handle(action: action)
        }
    }
        
    weak var parent: CoordinatorProtocol?
    var childs = [WeakCoordinator]()
    let navigationController: NavigationController
    let factory: CoordinatorFactoryProtocol
    let startRoute: ListRoute
    let servicesContainer: ServicesContainerProtocol
    
    
    init(parent: CoordinatorProtocol?, 
         navigationController: NavigationController,
         factory: CoordinatorFactoryProtocol, 
         startRoute: ListRoute = .main,
         services: ServicesContainerProtocol) {
        self.parent = parent
        self.navigationController = navigationController
        self.factory = factory
        self.startRoute = startRoute
        self.servicesContainer = services
    }
}

extension DataListCoordinator: RouterViewFactory {
    @ViewBuilder
    func view(for route: ListRoute) -> some View {
        switch route {
        case .main:
            ContentView<DataListCoordinator>(viewModel: .init(self.servicesContainer))
//        case .details:
//            EmptyView()
        }
    }
}
