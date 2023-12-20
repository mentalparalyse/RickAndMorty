//
//  JSONDecoderWrapper.swift
//  RickAndMorty
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation

protocol DataDecoderProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

class JSONDecoderWrapper: DataDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let result = try? decoder.decode(type, from: data) else {
            throw NetworkError.decodingError
        }
        return result
    }
}
