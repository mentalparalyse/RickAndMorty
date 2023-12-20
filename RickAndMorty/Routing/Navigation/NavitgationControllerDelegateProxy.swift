//
//  NavigationControllerDelegateProxy.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import SwiftUI

@MainActor
class NavigationControllerDelegateProxy: NSObject, UINavigationControllerDelegate {
    
    let transitionHandler: NavigationControllerTransitionHandler
    
    init(transitionHandler: NavigationControllerTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return transitionHandler.navigationController(
            navigationController,
            animationControllerFor: operation,
            from: fromVC,
            to: toVC
        )
    }
}
