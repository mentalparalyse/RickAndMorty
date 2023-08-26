//
//  LocationModel.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation


/**
 id    int    The id of the location.
 name    string    The name of the location.
 type    string    The type of the location.
 dimension    string    The dimension in which the location is located.
 residents    array (urls)    List of character who have been last seen in the location.
 url    string (url)    Link to the location's own endpoint.
 created    string    Time at which the location was created in the database.
 */


protocol LocationModelProtocol: Codable, Equatable {
    var id: Int { get set }
    var name: String { get set }
    var type: String { get set }
    var dimension: String { get set }
    var residents: [String] { get set }
}

struct LocationResultsModel: Codable {
    var results: [LocationModel]
    enum CodingKeys: CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([LocationModel].self, forKey: .results)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.results, forKey: .results)
    }
}

struct LocationModel: LocationModelProtocol {
    var id: Int
    var name: String
    var type: String
    var dimension: String
    var residents: [String]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(String.self, forKey: .type)
        self.dimension = try container.decode(String.self, forKey: .dimension)
        self.residents = try container.decode([String].self, forKey: .residents)
    }
    
    init(id: Int, name: String, type: String, dimension: String, residents: [String]) {
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residents = residents
    }
}
