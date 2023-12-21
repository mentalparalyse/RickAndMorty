//
//  CoordinatorFactory.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI


@MainActor
class RootCoordinator: CoordinatorProtocol {
    let parent: CoordinatorProtocol? = nil
    var childs = [WeakCoordinator]()
    var id: UUID
    private(set) var window: UIWindow
    private(set) var navigationController: NavigationController
    
    init(window: UIWindow, navigationController: NavigationController) {
        self.id = UUID()
        self.window = window
        self.navigationController = navigationController
        
        window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    func handle(action: CoordinatorAction) { }
}
