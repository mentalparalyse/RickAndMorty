//
//  Navigator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 14.12.2023.
//

import SwiftUI

typealias Routing = CoordinatorProtocol & Navigator

enum NavigatorError: Error {
    case unableToShow(NavigationRoute)
}

@MainActor
protocol Navigator: ObservableObject {
    associatedtype Route: NavigationRoute
    
    var navigationController: NavigationController { get }
    var startRoute: Route { get }
    var servicesContainer: ServicesContainerProtocol { get }
    
    func start() throws
    func show(route: Route) throws
    
    /// Creates view for routes.
    func set(routes: [Route], animated: Bool)
    /// Creates views for routes, and appends them on the navigation stack.
    func append(routes: [Route], animated: Bool)
    /// Pops the top view from the navigation stack.
    func pop(animated: Bool)
    /// Pops all the views on the stack except the root view.
    func popToRoot(animated: Bool)
    /// Dismisses the view.
    func dismiss(animated: Bool)
}

extension Navigator where Self: RouterViewFactory {
    var viewControllers: [UIViewController] {
        navigationController.viewControllers
    }
    
    var topViewController: UIViewController? {
        navigationController.topViewController
    }
    
    var visibleViewController: UIViewController? {
        navigationController.visibleViewController
    }
    
    func start() throws {
        try show(route: startRoute)
    }
    
    func show(route: Route) throws {
        let viewController = self.hostingController(for: route)
        navigationController.isNavigationBarHidden = route.title == nil
        
        switch route.transitionAction {
        case let .push(animated: animated):
            navigationController.pushViewController(viewController, animated: animated)
        case let .present(animated: animated, modalPresentationStyle: presentationStyle, delegate: delegate, completion):
            present(viewController: viewController, 
                    animated: animated,
                    modalPresentationStyle: presentationStyle,
                    delegate: delegate,
                    completion: completion)
        case .none:
            throw NavigatorError.unableToShow(route)
        }
        
    }
    
    func hostingController(for route: Route) -> UIHostingController<some View> {
        let view: some View = self.view(for: route)
            .ifLet(route.title) {
                $0.navigationTitle($1)
            }
            .if(route.attachCoordinator) {
                $0.environmentObject(self)
            }
            
        return RouteHostingController(rootView: view,
                                      route: route)
    }
    
    func present(
        viewController: UIViewController,
        animated: Bool,
        modalPresentationStyle: UIModalPresentationStyle,
        delegate: UIViewControllerTransitioningDelegate?,
        completion: (() -> Void)?
    ) {
        if let delegate {
            viewController.modalPresentationStyle = .custom
            viewController.transitioningDelegate = delegate
        } else {
            viewController.modalPresentationStyle = modalPresentationStyle
        }
        
        navigationController.present(viewController, animated: animated, completion: completion)
    }
    
    func set(routes: [Route], animated: Bool = true) {
        let views = views(for: routes)
        setViewControllers(views, animated: animated)
    }

    func append(routes: [Route], animated: Bool = true) {
        let views = views(for: routes)
        setViewControllers(viewControllers + views, animated: animated)
    }
    
    func setViewControllers<T>(_ controllers: [T], animated: Bool) where T: UIViewController {
        navigationController.isNavigationBarHidden = controllers.last?.title == nil
        navigationController.setViewControllers(controllers, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        if navigationController.presentationController != nil {
            navigationController.dismiss(animated: animated)
        }
        navigationController.popToRootViewController(animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        navigationController.dismiss(animated: animated)
    }
    
    func views(for routes: [Route]) -> [UIHostingController<some View>] {
        routes.map { hostingController(for: $0) }
    }
    
}
