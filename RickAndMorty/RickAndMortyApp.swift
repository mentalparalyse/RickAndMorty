//
//  RickAndMortyApp.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup { }
    }
    
}


final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var dependencyContainer = DependencyContainer()
    
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
    
    var services: ServicesContainerProtocol {
        let decoder = JSONDecoderWrapper()
        let networkService = NetworkService(session: session,
                                            decoder: decoder)
        let imageCacher = ImageCacher()
        let imageLoader = ImageLoader(imageCacher)
        return ServicesContainer(imageCacherService: imageCacher,
                                 imageLoaderService: imageLoader,
                                 networkService: networkService)
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = (scene as? UIWindowScene)?.windows.first else { return }
        let appCoordinator = dependencyContainer.makeAppCoordinator(window)
        dependencyContainer.set(appCoordinator)
        let listCoordinator = dependencyContainer.makeDataListCoordinator(appCoordinator, services)
        appCoordinator.start(listCoordinator)
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}
