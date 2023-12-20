//
//  NavigationFlow.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI

struct RouteAppearance {
    let backgroundColor: UIColor
    
    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
}

@MainActor
protocol NavigationRoute {
    var title: String? { get }
    var appearance: RouteAppearance? { get }
    var transitionAction: TransitionAction? { get }
    var attachCoordinator: Bool { get }
}

extension NavigationRoute {
    var title: String? {
        nil
    }
    var appearance: RouteAppearance? {
        nil
    }
    var attachCoordinator: Bool {
        true
    }
}

enum NavigationFlow: NavigationRoute {
    case splash, main, login, details
    
    var transitionAction: TransitionAction? {
        //Provide the presentation
        .push(animated: true)
    }
}
