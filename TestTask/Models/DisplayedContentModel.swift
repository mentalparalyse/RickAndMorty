//
//  DisplayedContentModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

protocol DisplayedDataProtocol: Identifiable {
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
    
    
    init(_ locationModel: LocationModel) {
        self.id = locationModel.id
        self.additionalInfo = locationModel.residents
        self.title = locationModel.name
        self.subTitle = locationModel.dimension
        self.imageUrl = nil
    }
    
    init(_ characterModel: CharacterModel) {
        self.id = characterModel.id
        self.title = characterModel.name
        self.subTitle = characterModel.gender
        self.imageUrl = characterModel.imageUrl
    }
    
    init(_ episodeModel: EpisodeModel) {
        self.id = episodeModel.id
        self.title = episodeModel.name
        self.subTitle = episodeModel.episode
        self.additionalInfo = episodeModel.characters
    }
}
