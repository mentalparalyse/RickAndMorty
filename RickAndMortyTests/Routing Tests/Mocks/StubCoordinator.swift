//
//  StubCoordinator.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import SwiftUI
import XCTest
@testable import RickAndMorty

@MainActor
class StubCoordinator: Routing {
    
    var id: UUID
    var navigationController: NavigationController
    var startRoute: StubRoute = .main
    var parent: CoordinatorProtocol?
    var childs = [WeakCoordinator]()
    var servicesContainer: ServicesContainerProtocol
    
    init(parent: CoordinatorProtocol?,
         startRoute: StubRoute = .main,
         servicesContainer: ServicesContainerProtocol,
         navigationController: NavigationController) {
        self.id = UUID()
        self.parent = parent
        self.startRoute = startRoute
        self.servicesContainer = servicesContainer
        self.navigationController = navigationController
    }
    func handle(action: CoordinatorAction) { }
}


extension StubCoordinator: RouterViewFactory {
    @ViewBuilder
    func view(for route: StubRoute) -> some View {
        switch route {
        case .main:
            StubContentView()
        case .details:
            StubDetailsView()
        default:
            EmptyView()
        }
    }
}
