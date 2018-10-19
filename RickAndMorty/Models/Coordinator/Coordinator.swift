//
//  Coordinator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 10/4/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

protocol Coordinator {
  var childControllers: [Coordinator] {get set}
  var navigationController: UINavigationController {get set}
  
  
  func start()
  func showDetailCharacter(_ character: CharacterViewData)
  func removeDetailView(_ view: UIView)
  func dismissController(_ controller: UIViewController)
  func prefersLargeTitle(_ prefer: Bool)
}


final class CharacterCoordinator: Coordinator{
  
  var childControllers = [Coordinator]()
  
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController){
    self.navigationController = navigationController
  }
  
  func removeDetailView(_ view: UIView) {
    UIView.animate(withDuration: 0.5, animations: {
       view.alpha = 0
    }) { (_) in
      view.removeFromSuperview()
    }
  }
  
  func dismissController(_ controller: UIViewController) {
    controller.dismiss(animated: true)
  }
  
  func prefersLargeTitle(_ prefer: Bool) {
    navigationController.navigationBar.prefersLargeTitles = prefer
    navigationController.navigationItem.largeTitleDisplayMode = prefer ? .never : .always
  }
  
  func showDetailCharacter(_ character: CharacterViewData) {
    guard let bundle = Bundle.main.loadNibNamed("DetailCharacterView",
                                                owner: nil,
                                                options: nil)?.first,
      let view = bundle as? DetailCharacterView else{
      fatalError("No View detected")
    }
    let frame = navigationController.view.frame
    view.frame = frame
    view.coordinator = self
    view.characterViewData = character
    view.alpha = 0
    navigationController.view.addSubview(view)
    UIView.animate(withDuration: 0.5) {
      view.alpha = 1
    }
  }

  
  func start() {
    let charactersConotroller = RAMCharacterController()
    charactersConotroller.coordinator = self
    charactersConotroller.title = "Rick and Morty"
    navigationController.pushViewController(charactersConotroller,
                                            animated: false)
  }
}
