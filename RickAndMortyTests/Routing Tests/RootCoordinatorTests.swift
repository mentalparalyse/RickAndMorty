//
//  RootCoordinatorTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 21.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class RootCoordinatorTests: XCTestCase {

    func test_root_viewController_initialization() {
        let navigationController = NavigationController()
        let window = UIWindow()
        let sut = StubAppCoordinator(window: window, navigationController: navigationController)
        
        XCTAssertEqual(sut.window, window)
        XCTAssertTrue(sut.childs.isEmpty)
        XCTAssertFalse(sut.window.isHidden)
        XCTAssertEqual(sut.window.rootViewController, navigationController)
        
    }
}
