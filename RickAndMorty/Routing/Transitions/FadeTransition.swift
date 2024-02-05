//
//  FadeTransition.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import UIKit

final class FadeTransition: NSObject, Transitionable, UIViewControllerAnimatedTransitioning {
    func isEligible(from fromRoute: NavigationRoute, to toRoute: NavigationRoute, _ operation: NavigationOperation) -> Bool {
        (fromRoute as? SplashRouting) == .splash && (toRoute as? SplashRouting) == .main
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            return transitionContext.completeTransition(false)
        }
        
        let contentView = transitionContext.containerView
        contentView.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
