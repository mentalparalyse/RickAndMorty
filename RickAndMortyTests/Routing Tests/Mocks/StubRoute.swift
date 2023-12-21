//
//  StubRoute.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

enum StubRoute: NavigationRoute {
    case main, details, settings
    
    var transitionAction: TransitionAction? {
        self != .settings ? .push(animated: true) : nil
    }
}
