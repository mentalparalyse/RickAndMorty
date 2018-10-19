//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import ObjectMapper


final class CharacterModel: Mappable{
  public struct Info: Mappable{
    var count: Int?
    var pages: Int?
    var next: String?
    var prev: String?
    public init?(map: Map) {
    }
    
    public mutating func mapping(map: Map) {
      self.count <- map["count"]
      self.pages <- map["pages"]
      self.next <- map["next"]
      self.prev <- map["prev"]
    }
  }
  
  
  public struct Location: Mappable{
    var name: String?
    var url: String?
    
    init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
      self.name <- map["name"]
      self.url <- map["url"]
    }
  }
  
  public struct Origin: Mappable {
    
    var name: String?
    var url: String?
    
    public init?(map: Map) {
      
    }
    
    mutating func mapping(map: Map) {
      self.name <- map["name"]
      self.url <- map["url"]
    }
  }
  
  public struct CharacterInfo: Mappable{
    var id: Int = 0
    var name: String = ""
    var status: String = ""
    var species: String = ""
    var type: String = ""
    var gender: String = ""
    var image: String = ""
    var url: String = ""
    var created: String = ""
    
    
    init?(map: Map) {
      self.id <- map["id"]
      self.name <- map["name"]
      self.status <- map["status"]
      self.species <- map["species"]
      self.type <- map["type"]
      self.gender <- map["gender"]
      self.image <- map["image"]
      self.url <- map["url"]
      self.created <- map["created"]
    }
    
    mutating func mapping(map: Map) {
    }
  }
  
  public struct Results: Mappable{
    var location: Location!
    var origin: Origin!
    var episode: [String] = []
    var characterInfo: CharacterInfo!
    
    public init?(map: Map) {
    }
    
    public mutating func mapping(map: Map) {
      self.characterInfo = CharacterInfo(map: map)
      self.location <- map["location"]
      self.origin <- map["origin"]
      self.episode <- map["episode"]
    }
  }
  
  
  public var info: Info?
  public var characterInfo: [Results] = []
  
  init?(map: Map) {
  }
  
  func mapping(map: Map) {
    self.info <- map["info"]
    self.characterInfo <- map["results"]
  }
}
