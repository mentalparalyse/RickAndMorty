//
//  NavigationControllerTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class NavigationControllerTests: XCTestCase {
    
    func test_navigation_bar_is_hidden() {
        let sut = NavigationController()
        XCTAssertTrue(sut.isNavigationBarHidden)
    }
    
    func test_navigation_bar_is_not_hidden() {
        let sut = NavigationController(isNavigationBarHidden: false)
        XCTAssertFalse(sut.isNavigationBarHidden)
    }
}
