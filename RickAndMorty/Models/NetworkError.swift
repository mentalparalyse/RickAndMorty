//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError
    case failure(Error)
}
