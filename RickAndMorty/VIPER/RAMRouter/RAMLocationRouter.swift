//
//  RAMLocationRouter.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/30/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

final class RAMRouter: RAMPresenterToRouterProtocol{
  
  static func createModule() -> UIViewController {
    let locationController = RAMLocationsController()
    
    let presenter: RAMViewToPresenterProtocol & RAMInterectorToPresenterProtocol = RAMLocationPresenter()
    let interector: RAMPresenterToInterectorProtocol = LocationInterector()
    let router: RAMPresenterToRouterProtocol = RAMRouter()
    
    locationController.presenter = presenter
    presenter.view = locationController
    presenter.router = router
    presenter.interector = interector
    interector.presenter = presenter
    
    return locationController
  }
}
