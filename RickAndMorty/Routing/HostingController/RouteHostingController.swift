//
//  RouteHostingController.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11.12.2023.
//

import SwiftUI

@MainActor
class RouteHostingController<Content: View>: UIHostingController<Content>, RouteProvider {
    let route: NavigationRoute
    
    init(rootView: Content, route: NavigationRoute) {
        self.route = route
        super.init(rootView: rootView)
    }
    
    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if let appearance = route.appearance {
            view.backgroundColor = appearance.backgroundColor
        }
    }
}
