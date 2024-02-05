//
//  EpisodeModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

protocol EpisodeModelProtocol: Identifiable, Equatable, Codable {
    var id: Int { get }
    var name: String { get }
    var airDate: String { get }
    var episode: String { get }
    var characters: [String] { get }
}

/**
 Location Model, conforms to Equatable/Codable and Identifiable protocols.

 - Parameters:
    - id:    int    The id of the episode.
    - name:    string    The name of the episode.
    - air_date:    string    The air date of the episode.
    - episode:    string    The code of the episode.
    - characters:    array (urls)    List of characters who have been seen in the episode.
 */

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
