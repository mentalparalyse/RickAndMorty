//
//  ResponseModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation

protocol ResponseModelProtocol: Codable {
    associatedtype T
    var info: ResultInfo? { get }
    var results: [T] { get }
}

struct EpisodeModelResult: ResponseModelProtocol {
    typealias T = EpisodeModel
    var info: ResultInfo?
    var results: [T] = []
}

struct LocationResultsModel: ResponseModelProtocol {
    typealias T = LocationModel
    var info: ResultInfo?
    var results: [T] = []
}

struct CharacterResultsModel: ResponseModelProtocol {
    typealias T = CharacterModel
    var info: ResultInfo?
    var results: [T] = []
}
