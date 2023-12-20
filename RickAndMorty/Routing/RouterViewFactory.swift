//
//  RouterViewFactory.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI

@MainActor
protocol RouterViewFactory {
    associatedtype V: View
    associatedtype Route: NavigationRoute
    @ViewBuilder
    func view(for route: Route) -> V
}

protocol RouteProvider {
    var route: NavigationRoute { get }
}
