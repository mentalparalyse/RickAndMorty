//
//  CharacterModel.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation

protocol CharacterModelProtocol: Equatable, Codable {
    var id: Int { get set }
    var name: String { get set }
    var status: String { get set }
    var species: String { get set }
    var type: String { get set }
    var gender: String { get set }
    var imageUrl: String { get set }
}

enum CharacterStatus: String {
    case dead, alive, unknown, test
    
    var statusColor: UInt {
        switch self {
        case .dead:
            return 0xE82727
        case .alive:
            return 0x23CE3E
        case .unknown:
            return 0xB1B1B1
        case .test:
            return 0x0926BE
        }
    }
}

/**
 Character Model, conforms to Equatable/Codable.
 
- Parameters:
    - id:    int    The id of the character.
    - name:    string    The name of the character.
    - status:    string    The status of the character ('Alive', 'Dead' or 'unknown').
    - species:    string    The species of the character.
    - type:    string    The type or subspecies of the character.
    - gender:    string    The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    - origin:   object    Name and link to the character's origin location.
    - location:    object    Name and link to the character's last known location endpoint.
    - image:    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    - episode:    array (urls)    List of episodes in which this character appeared.
    - url:    string (url)    Link to the character's own URL endpoint.
    - created:    string    Time at which the character was created in the database.
*/
struct CharacterModel: CharacterModelProtocol {
    static func == (lhs: CharacterModel, rhs: CharacterModel) -> Bool {
        lhs.id == rhs.id
    }
    
    struct Location: Codable {
        var name: String = "Dorian 5"
    }
    
    struct Origin: Codable {
        var name: String = "unknown"
    }
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var imageUrl: String
    var origin: Origin
    var location: Location
    var episode: [String]
    
    var characterStatus: CharacterStatus {
        return .init(rawValue: status) ?? .test
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status
        case species
        case type
        case gender
        case imageUrl = "image"
        case origin, location, episode
    }
    init() {
        self.id = 0
        self.name = "Diablo Verde"
        self.status = "Dead"
        self.species = "Mythological Creature"
        self.type = "Demon"
        self.gender = "Male"
        self.imageUrl = "https://rickandmortyapi.com/api/character/avatar/93.jpeg"
        self.location = .init()
        self.origin = .init()
        self.episode = [""]
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
        self.location = try container.decode(Location.self, forKey: .location)
        self.origin = try container.decode(Origin.self, forKey: .origin)
        self.episode = try container.decode([String].self, forKey: .episode)
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
        try container.encode(self.location, forKey: .location)
        try container.encode(self.origin, forKey: .origin)
        try container.encode(self.episode, forKey: .episode)

    }
}

extension CharacterModel {
    static var mock: Self {
        return .init()
    }
}
