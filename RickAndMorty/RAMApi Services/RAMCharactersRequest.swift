//
//  RAMCharactersRequest.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import RxSwift
import RxCocoa

final class CharacterRequest{
  typealias ResponseCharacters = Observable<CharacterModel>
  public func getCahactersAsObservable(_ link: URL) -> ResponseCharacters{
    let request = Alamofire.request(link)
    return Observable.create({ (observer) -> Disposable in
      request
        .responseJSON(completionHandler: { (responseData) in
          switch responseData.result{
          case .success(let json):
            guard let status = responseData.response?.statusCode,
              status == 200 else {
                return
            }
            if let character = Mapper<CharacterModel>()
              .map(JSONObject: json) {
              observer.onNext(character)
              observer.onCompleted()
            }
          case .failure(let error):
            observer.onError(error)
            break
          }
        })
      return Disposables.create {
        request.cancel()
      }
    })
  }
}
