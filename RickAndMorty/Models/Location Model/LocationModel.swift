//
//  LocationModel.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/13/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import ObjectMapper

final class LocationModel: Mappable{
    
    struct Info: Mappable{
        var count: Int!
        var pages: Int!
        var next: String!
        var prev: String!
        
        init?(map: Map) {
            self.count <- map["count"]
            self.pages <- map["pages"]
            self.next <- map["next"]
            self.prev <- map["prev"]
        }
        
        mutating func mapping(map: Map) {
        }
    }
    
    struct Results: Mappable{
        var id: Int!
        var name: String!
        var type: String!
        var dimension: String!
        var residents: [String]!
        var url: String!
        var created: String!
        
        init?(map: Map) {
            self.id <- map["id"]
            self.name <- map["name"]
            self.type <- map["type"]
            self.dimension <- map["dimension"]
            self.residents <- map["residents"]
            self.url <- map["url"]
            self.created <- map["created"]
        }
        
        mutating func mapping(map: Map) {
        }
    }
    
    public var info: Info!
    public var results: [Results]!
    
    internal init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.info <- map["info"]
        self.results <- map["results"]
    }
}


