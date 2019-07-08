//
//  CharacterPresenter.swift
//  RickAndMorty
//
//  Created by Lex Sava on 10/1/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CharacterPresenter{
  private let characterService: CharacterRequest
  weak private var characterView: CharacterView?
  private var nextPage: String?
  private var bag = DisposeBag()
  
  
  init(characterService: CharacterRequest) {
    self.characterService = characterService
  }
  
  public func attachView(_ view: CharacterView){
    self.characterView = view
  }
  
  public func deatachView(){
    self.characterView = nil
  }
  
  public func loadMoreCharacters(){
    self.characterView?.startAnimating()
    guard let urlString = nextPage,
      let url = URL(string: urlString) else {
        fatalError("no string detected")
    }
    
    let characters = characterService.getCahactersAsObservable(url)
    characters.subscribe(onNext: { (model) in
      self.nextPage = model.info?.next
      
      let fullData = model.characterInfo.map({
        return $0
      })
      
      let viewData = fullData.map({
        return CharacterViewData(name: $0.characterInfo.name,
                                 imageURL: $0.characterInfo.image,
                                 id: $0.characterInfo.id,
                                 created: $0.characterInfo.created,
                                 status: $0.characterInfo.status,
                                 species: $0.characterInfo.species,
                                 gender: $0.characterInfo.gender,
                                 origin: $0.origin.name ?? "",
                                 lastLocation: $0.location.name ?? "")
      })
      
      self.characterView?.loadNextCharacters(viewData)
    }, onError: { (error) in
      print(error.localizedDescription)
      self.characterView?.setEmptyCharacter()
    }, onCompleted: {
      self.characterView?.stopAnimating()
    }).disposed(by: bag)
  }
  
  
  public func getObservableCharacters(){
    self.characterView?.startAnimating()
    let url = Links.charactersLink!
    let characters = characterService.getCahactersAsObservable(url)
    
    characters.subscribe(onNext: { (model) in
      self.nextPage = model.info?.next
      let fullData = model.characterInfo.map({
        return $0
      })

      let viewData = fullData.map({
        return CharacterViewData(name: $0.characterInfo.name,
                                 imageURL: $0.characterInfo.image,
                                 id: $0.characterInfo.id,
                                 created: $0.characterInfo.created,
                                 status: $0.characterInfo.status,
                                 species: $0.characterInfo.species,
                                 gender: $0.characterInfo.gender,
                                 origin: $0.origin.name ?? "",
                                 lastLocation: $0.location.name ?? "")
      })
      
      self.characterView?.setCharacters(viewData)
    }, onError: { (error) in
      print(error.localizedDescription)
      self.characterView?.setEmptyCharacter()
    }, onCompleted: {
      self.characterView?.stopAnimating()
    }).disposed(by: bag)
  }
}
