//
//  NavigationControllerTransitionHandlerTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class NavigationControllerTransitionHandlerTests: XCTestCase {
    
    var provider: TransitionProvider!
    var handler: NavigationControllerTransitionHandler!
    
    override func tearDown() {
        provider = nil
        handler = nil
    }
    
    func test_animation_for_eliglible_routes() {
        provider = TransitionProvider(transitions: [StubTransition(), StubTransition()])
        handler = NavigationControllerTransitionHandler(transitionProvider: provider)
        
        let mockFromVC = RouteHostingController(rootView: StubContentView(), route: StubRoute.main)
        let mockToVC = RouteHostingController(rootView: StubDetailsView(), route: StubRoute.details)
        
        let sut = handler.navigationController(NavigationController(),
                                                         animationControllerFor: .push,
                                                         from: mockFromVC,
                                                         to: mockToVC)
        XCTAssertTrue(sut is StubTransition)
    }
    
    func test_animation_for_no_matching_transitions() {
        provider = TransitionProvider(transitions: [])
        handler = NavigationControllerTransitionHandler(transitionProvider: provider)
        
        let mockFromVC = RouteHostingController(rootView: StubContentView(), route: StubRoute.main)
        let mockToVC = RouteHostingController(rootView: StubDetailsView(), route: StubRoute.details)
        
        let sut = handler.navigationController(NavigationController(),
                                                         animationControllerFor: .push,
                                                         from: mockFromVC,
                                                         to: mockToVC)
        XCTAssertNil(sut)
    }
}
