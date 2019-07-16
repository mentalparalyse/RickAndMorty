//
//  CharacterServices.swift
//  RickAndMorty
//
//  Created by Lex Sava on 10/1/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct CharacterViewData{
  var name: String
  var imageURL: String
  var id: Int
  var created: String
  var status: String
  var species: String
  var gender: String
  var origin: String
  var lastLocation: String
}

protocol CharacterView: NSObjectProtocol {
  func loadNextCharacters(_ characters: [CharacterViewData])
  func startAnimating()
  func stopAnimating()
  func setEmptyCharacter()
  func setCharacters(_ characters: [CharacterViewData])
}
