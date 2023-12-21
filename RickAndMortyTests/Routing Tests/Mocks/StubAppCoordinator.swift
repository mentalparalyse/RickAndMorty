//
//  StubAppCoordinator.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

final class StubAppCoordinator: RootCoordinator {
    func start(with coordinator: any Routing) {
        self.add(child: coordinator)
        try? coordinator.start()
    }
    
    override func handle(action: CoordinatorAction) {
        fatalError("Unhandled coordinator action")
    }
}
