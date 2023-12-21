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
    
    var navigationController: NavigationController
    var startRoute: StubRoute = .main
    var parent: CoordinatorProtocol?
    var childs = [WeakCoordinator]()
    var id: UUID
    
    init(parent: CoordinatorProtocol?,
         startRoute: StubRoute = .main,
         navigationController: NavigationController) {
        self.id = UUID()
        self.parent = parent
        self.startRoute = startRoute
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
