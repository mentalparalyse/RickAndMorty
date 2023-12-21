//
//  TransitionProviderTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 21.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class TransitionProviderTests: XCTestCase {
    
    func test_transition_provider_initialization() {
        let transitions = [StubTransition(), StubTransition()]
        let sut = TransitionProvider(transitions: transitions)
        
        XCTAssertEqual(sut.transitions.count, transitions.count)
        XCTAssertNotNil(sut.transitions.first?.transition)
    }

    func test_weak_transition_doesnt_retain() {
        var transition: Transitionable? = StubTransition()
        let weakTransition: WeakTransition? = .init(transition: transition!)
        XCTAssertNotNil(weakTransition?.transition)
        transition = nil
        XCTAssertNil(weakTransition?.transition)
    }
    
}
