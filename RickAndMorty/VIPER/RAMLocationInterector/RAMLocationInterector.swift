//
//  RAMLocationInterector.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/30/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

final class LocationInterector: RAMPresenterToInterectorProtocol {
    var presenter: RAMInterectorToPresenterProtocol?
    
    internal func fetchLocations(_ link: URL) {
        Alamofire.request(link).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                guard let code = response.response?.statusCode, code == 200 else{
                    return
                }
                if let location = Mapper<LocationModel>().map(JSONObject: json){
                    self.presenter?.locationsFetched(locations: location)
                }
                
            case .failure(let error):
                self.presenter?.failedToFetch(with: error)
                break
            }
        }
    }
    
}
