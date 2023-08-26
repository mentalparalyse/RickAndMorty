//
//  CharacterModel.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation

/**

 id    int    The id of the character.
 name    string    The name of the character.
 status    string    The status of the character ('Alive', 'Dead' or 'unknown').
 species    string    The species of the character.
 type    string    The type or subspecies of the character.
 gender    string    The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
 origin    object    Name and link to the character's origin location.
 location    object    Name and link to the character's last known location endpoint.
 image    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
 episode    array (urls)    List of episodes in which this character appeared.
 url    string (url)    Link to the character's own URL endpoint.
 created    string    Time at which the character was created in the database.
*/



protocol CharacterModelProtocol: Equatable, Codable {
    var id: Int { get set }
    var name: String { get set }
    var status: String { get set }
    var species: String { get set }
    var type: String { get set }
    var gender: String { get set }
    var imageUrl: String { get set }
}

//"info": {
//   "count": 826,
//   "pages": 42,
//   "next": "https://rickandmortyapi.com/api/character/?page=2",
//   "prev": null
// },

struct ResultInfo: Codable {
    var count: Int
    var pages: Int
    var next: String
    var prev: String?
    enum CodingKeys: CodingKey {
        case count
        case pages
        case next
        case prev
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.pages = try container.decode(Int.self, forKey: .pages)
        self.next = try container.decode(String.self, forKey: .next)
        self.prev = try container.decodeIfPresent(String.self, forKey: .prev)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.count, forKey: .count)
        try container.encode(self.pages, forKey: .pages)
        try container.encode(self.next, forKey: .next)
        try container.encodeIfPresent(self.prev, forKey: .prev)
    }
}

struct CharacterResultsModel: Codable {
    var info: ResultInfo?
    var results: [CharacterModel]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([CharacterModel].self, forKey: .results)
        self.info = try? container.decode(ResultInfo.self, forKey: .info)
    }
    
    enum CodingKeys: CodingKey {
        case info
        case results
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.results, forKey: .results)
        try? container.encode(self.info, forKey: .info)
    }
}

struct CharacterModel: CharacterModelProtocol {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status
        case species
        case type
        case gender
        case imageUrl = "image"
    }
    init() {
        self.id = 0
        self.name = "name"
        self.status = "status"
        self.species = "species"
        self.type = "type"
        self.gender = "gender"
        self.imageUrl = "imageUrl"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(String.self, forKey: .status)
        self.species = try container.decode(String.self, forKey: .species)
        self.type = try container.decode(String.self, forKey: .type)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.species, forKey: .species)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.gender, forKey: .gender)
        try container.encode(self.imageUrl, forKey: .imageUrl)
    }
    
}
