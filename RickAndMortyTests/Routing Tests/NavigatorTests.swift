//
//  NavigatorTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class NavigatorTests: XCTestCase {
    
    func test_route_throws_error() {
        let sut = StubCoordinator(parent: nil, startRoute: .main, navigationController: NavigationController())
        XCTAssertNoThrow(try sut.start())
        XCTAssertThrowsError(try sut.show(route: .settings)) { error in
            guard let error = error as? NavigatorError else {
                return XCTFail("Cannot cast to navigator error: \(error)")
            }
            switch error {
            case .unableToShow(let route as StubRoute):
                XCTAssertEqual(route, .settings)
            default:
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
    
}
