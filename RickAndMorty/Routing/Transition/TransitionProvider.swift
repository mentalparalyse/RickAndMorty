//
//  TransitionProvider.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import Foundation

@MainActor
protocol TransitionProvidable {
    var transitions: [WeakTransition] { get }
}

final class TransitionProvider: TransitionProvidable {
    
    private(set) var transitions: [WeakTransition]
    
    private var _transitions: [Transitionable]
    
    init(transitions: [Transitionable]) {
        self._transitions = transitions
        self.transitions = transitions.map { .init(transition: $0) }
    }
    
}


