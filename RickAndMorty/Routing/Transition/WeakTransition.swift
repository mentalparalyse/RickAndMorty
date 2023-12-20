//
//  WeakTransition.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import Foundation

final class WeakTransition {
    private(set) weak var transition: Transitionable?
    
    init(transition: Transitionable) {
        self.transition = transition
    }
}
