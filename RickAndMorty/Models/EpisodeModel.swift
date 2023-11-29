//
//  EpisodeModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

//{
//  "info": {
//    "count": 51,
//    "pages": 3,
//    "next": "https://rickandmortyapi.com/api/episode?page=2",
//    "prev": null
//  },
//  "results": [
//    {
//      "id": 1,
//      "name": "Pilot",
//      "air_date": "December 2, 2013",
//      "episode": "S01E01",
//      "characters": [
//        "https://rickandmortyapi.com/api/character/1",
//        "https://rickandmortyapi.com/api/character/2",
//        //...
//      ],
//      "url": "https://rickandmortyapi.com/api/episode/1",
//      "created": "2017-11-10T12:56:33.798Z"
//    },
//    // ...
//  ]
//}



protocol EpisodeModelProtocol: Identifiable, Equatable, Codable {
    var id: Int { get }
    var name: String { get }
    var airDate: String { get }
    var episode: String { get }
    var characters: [String] { get }
}




struct EpisodeModel: EpisodeModelProtocol {
    var id: Int
    var name: String
    var airDate: String
    var episode: String
    var characters: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters
        case airDate = "air_date"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.episode = try container.decode(String.self, forKey: .episode)
        self.name = try container.decode(String.self, forKey: .name)
        self.airDate = try container.decode(String.self, forKey: .airDate)
        self.characters = try container.decode([String].self, forKey: .characters)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.airDate, forKey: .airDate)
        try container.encode(self.characters, forKey: .characters)
    }
    
    init(
        id: Int,
        name: String,
        airDate: String,
        episode: String,
        characters: [String]
    ) {
        self.id = id
        self.name = name
        self.airDate = airDate
        self.episode = episode
        self.characters = characters
    }
}
