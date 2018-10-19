//
//  AccessLinks.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

enum Links{
  private static let charString = "https://rickandmortyapi.com/api/character/"
  private static let locString = "https://rickandmortyapi.com/api/location"
  private static let epString = "https://rickandmortyapi.com/api/episode"
  
  static let charactersLink = URL(string: charString)
  static let locationsLink = URL(string: locString)
  static let episodesLink = URL(string: epString)
}
