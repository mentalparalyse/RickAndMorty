//
//  NavigationControllerFactory.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import SwiftUI

@MainActor
protocol NavigationControllerCreatable {
    func makeNavigationDelegate(
        _ transitions: [Transitionable]
    ) -> NavigationControllerDelegateProxy
    func makeNavigationController(
        isNavigationBarHidden: Bool,
        delegate: NavigationControllerDelegateProxy?
    ) -> NavigationController
}


final class NavigationControllerFactory: NavigationControllerCreatable {
    
    init() { }
    
    func makeNavigationController(
        isNavigationBarHidden: Bool = true,
        delegate: NavigationControllerDelegateProxy?
    ) -> NavigationController {
        NavigationController(isNavigationBarHidden: isNavigationBarHidden, delegate: delegate)
    }
    
    func makeNavigationDelegate(
        _ transitions: [Transitionable]
    ) -> NavigationControllerDelegateProxy {
        let transitionProvider = TransitionProvider(transitions: transitions)
        let transitionHandler = NavigationControllerTransitionHandler(transitionProvider: transitionProvider)
        return NavigationControllerDelegateProxy(transitionHandler: transitionHandler)
    }
}
