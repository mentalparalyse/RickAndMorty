//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import Foundation

class AppCoordinator: RootCoordinator {
    func start(_ coordinator: any Routing) {
        self.add(child: coordinator)
        try? coordinator.start()
    }
    
    override func handle(action: CoordinatorAction) {
        fatalError("Unhandled action.")
    }
}
