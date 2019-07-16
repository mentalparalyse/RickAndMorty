//
//  RAMLocationPresenter.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/30/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

final class RAMLocationPresenter: RAMViewToPresenterProtocol{
    var interector: RAMPresenterToInterectorProtocol?
    var view: RAMPresenterToViewProtocol?
    var router: RAMPresenterToRouterProtocol?
    var link: URL?
    
    func updateView() {
        interector?.fetchLocations(link ?? Links.charactersLink!)
    }
}

extension RAMLocationPresenter: RAMInterectorToPresenterProtocol{
    internal func locationsFetched(locations: LocationModel) {
        view?.showLocations(locations: locations)
        let url = URL(string: locations.info!.next)
        self.link = url
    }
    
    internal func failedToFetch(with error: Error) {
        view?.showError(error: error)
    }
}
