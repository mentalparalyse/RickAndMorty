//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var coordinator: CharacterCoordinator?
  
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let characterNavigation = UINavigationController()
    
    coordinator = CharacterCoordinator(navigationController: characterNavigation)
//    coordinator?.prefersLargeTitle(true)
    coordinator?.start()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = characterNavigation
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
  func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
    return .portrait
  }
}

