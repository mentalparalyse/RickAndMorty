//
//  DisplayedContentModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

protocol DisplayedDataProtocol: Identifiable, Equatable {
    var id: Int { get }
    var title: String { get }
    var subTitle: String { get }
    var imageUrl: String? { get }
    var hasChevron: Bool { get }
    var additionalInfo: [String]? { get }
}

struct DisplayedData: DisplayedDataProtocol {
    var id: Int
    var title: String
    var subTitle: String
    var imageUrl: String?
    var additionalInfo: [String]?
    
    var hasChevron: Bool {
        additionalInfo != nil
    }
    
    var isMock: Bool {
        id == -999
    }
    
    init(
        id: Int,
        title: String,
        subTitle: String,
        imageUrl: String? = nil,
        additionalInfo: [String]? = nil
    ) {
        self.id = id
        self.additionalInfo = additionalInfo
        self.title = title
        self.subTitle = subTitle
        self.imageUrl = imageUrl
    }
    
    init(location model: LocationModel) {
        self.id = model.id
        self.additionalInfo = model.residents
        self.title = model.name
        self.subTitle = model.dimension
    }
    
    init(character model: CharacterModel) {
        self.id = model.id
        self.title = model.name
        self.subTitle = model.gender
        self.imageUrl = model.imageUrl
    }
    
    init(episode model: EpisodeModel) {
        self.id = model.id
        self.title = model.name
        self.subTitle = model.episode
        self.additionalInfo = model.characters
    }
}

extension DisplayedData {
    static var mock: Self {
        return .init(id: -999, title: "Name", subTitle: "Gender", additionalInfo: [
            "https://rickandmortyapi.com/api/character/1",
            "https://rickandmortyapi.com/api/character/2",
        ])
    }
}
