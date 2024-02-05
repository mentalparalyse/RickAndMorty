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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = (scene as? UIWindowScene)?.windows.first else { return }
        let appCoordinator = dependencyContainer.makeAppCoordinator(window)
        dependencyContainer.set(appCoordinator)
        let splashCoordinator = dependencyContainer.makeSplashScreenCoordinator(appCoordinator)
        appCoordinator.start(splashCoordinator)
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
