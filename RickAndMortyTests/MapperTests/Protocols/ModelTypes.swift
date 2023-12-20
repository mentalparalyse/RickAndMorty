//
//  ModelTypes.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation

enum ModelTypes: String {
    case character, location, episode, none
    
    var modelName: String {
        return rawValue.capitalized + "Model"
    }
}
