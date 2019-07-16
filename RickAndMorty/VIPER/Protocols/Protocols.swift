//
//  Protocols.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/30/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

protocol RAMPresenterToViewProtocol: class {
  func showLocations(locations: LocationModel)
  func showError(error: Error)
}

protocol RAMInterectorToPresenterProtocol: class {
  func locationsFetched(locations: LocationModel)
  func failedToFetch(with error: Error)
}

protocol RAMPresenterToInterectorProtocol: class {
  var presenter: RAMInterectorToPresenterProtocol? {get set}
  func fetchLocations(_ link: URL)
}

protocol RAMViewToPresenterProtocol: class {
  var view: RAMPresenterToViewProtocol? {get set}
  var interector: RAMPresenterToInterectorProtocol? {get set}
  var router: RAMPresenterToRouterProtocol? {get set}
  var link: URL? {get set}
  func updateView()
}

protocol RAMPresenterToRouterProtocol: class {
  static func createModule() -> UIViewController
}
