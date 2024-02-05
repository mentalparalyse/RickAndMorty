//
//  DependencyContainer.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import SwiftUI

@MainActor
class DependencyContainer {
    let factory = NavigationControllerFactory()
    lazy var delegate = factory.makeNavigationDelegate([FadeTransition()])
    lazy var navigationController = factory.makeNavigationController(delegate: delegate)
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
    
    lazy var services: ServicesContainerProtocol  = {
        let decoder = JSONDecoderWrapper()
        let networkService = NetworkService(session: session,
                                            decoder: decoder)
        let imageCacher = ImageCacher()
        let imageLoader = ImageLoader(imageCacher)
        return ServicesContainer(imageCacherService: imageCacher,
                                 imageLoaderService: imageLoader,
                                 networkService: networkService)
    }()
    
    
    
    private(set) var appCoordinator: AppCoordinator?
    
    func set(_ coordinator: AppCoordinator) {
        guard appCoordinator == nil else { return }
        appCoordinator = coordinator
    }
}

extension DependencyContainer: CoordinatorFactoryProtocol {
    func makeDataListCoordinator(_ parent: CoordinatorProtocol) -> DataListCoordinator {
        DataListCoordinator(parent: parent,
                            navigationController: navigationController,
                            factory: self,
                            services: self.services)
    }
    
    func makeSplashScreenCoordinator(_ parent: CoordinatorProtocol) -> SplashCoordinator {
        SplashCoordinator(parent: parent, 
                          navigationController: navigationController,
                          factory: self,
                          services: self.services)
    }
    
    func makeAppCoordinator(_ window: UIWindow) -> AppCoordinator {
        AppCoordinator(window: window,
                       navigationController: navigationController)
    }
}
