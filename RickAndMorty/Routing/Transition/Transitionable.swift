//
//  Transitionable.swift
//  RickAndMorty
//
//  Created by Lex Sava on 12.12.2023.
//

import SwiftUI

typealias NavigationOperation = UINavigationController.Operation

@MainActor
protocol Transitionable: UIViewControllerAnimatedTransitioning {
    func isEligible(
        from fromRoute: NavigationRoute,
        to toRoute: NavigationRoute,
        _ operation: NavigationOperation
    ) -> Bool
}
