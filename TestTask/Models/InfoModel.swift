//
//  InfoModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

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
