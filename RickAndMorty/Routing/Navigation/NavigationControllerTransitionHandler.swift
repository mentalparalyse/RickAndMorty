//
//  NavigationControllerTransitionHandler.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import SwiftUI

@MainActor
class NavigationControllerTransitionHandler: NSObject, UINavigationControllerDelegate {
    
    let transitionProvider: TransitionProvider
    
    init(transitionProvider: TransitionProvider) {
        self.transitionProvider = transitionProvider
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        guard let fromRoute = fromVC.toRouteProvider?.route,
                let toRoute = toVC.toRouteProvider?.route else {
            return nil
        }
        if let transition = transitionProvider.transitions
            .compactMap({ $0.transition })
            .first(where: { $0.isEligible(from: fromRoute, to: toRoute, operation) }) {
            return transition
        }
        return nil
    }
}

extension UIViewController {
    var toRouteProvider: RouteProvider? {
        self as? RouteProvider
    }
}
