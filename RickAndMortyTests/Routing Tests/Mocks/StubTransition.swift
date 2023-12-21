//
//  StubTransition.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import UIKit
import XCTest
@testable import RickAndMorty

class StubTransition: NSObject, Transitionable {
    func isEligible(from fromRoute: NavigationRoute, to toRoute: NavigationRoute, _ operation: NavigationOperation) -> Bool {
        return fromRoute as? StubRoute == .main
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        let containerView = transitionContext.containerView
        toView.alpha = 0.0
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toView.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
