//
//  CellConfigurator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/28/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit


//MARK:- Required spaces
protocol Character {
  var name: String { get }
  var id: Int { get }
  var imageUrl: String { get }
  var created: String { get }
}

//MARK:- Cell configuration from here
struct CellConfig: Character{
  var name: String
  var id: Int
  var imageUrl: String
  var created: String
  
  init(name: String, id: Int, imageUrl: String, created: String){
    self.name = name
    self.id = id
    self.imageUrl = imageUrl
    self.created = created
  }
}
