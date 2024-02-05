//
//  NetworkService.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation
import Combine

enum AccessLinks: String, CaseIterable {
    case character = "character"
    case location = "location"
    case episode = "episode"
    
    var initialLink: String {
        "https://rickandmortyapi.com/api/".appending(rawValue)
    }
}


protocol NetworkServiceProtocol {
    func load<T, U>(model: T.Type, link: U) async -> Result<T?, NetworkError> where T: Codable, U: StringProtocol
    func performRequest<T: Codable>(with modelType: T.Type, _ urlRequest: URLRequest) async throws -> Result<T?, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    private var baseURL = URL(string: "https://rickandmortyapi.com/api/")
    private var session: URLSession
    private var decoder: DataDecoderProtocol
    
    init(session: URLSession, decoder: DataDecoderProtocol) {
        self.session = session
        self.decoder = decoder
    }
    
    @discardableResult
    func load<T, U>(model: T.Type, link: U) async -> Result<T?, NetworkError> where T: Codable, U: StringProtocol {
        do {
            guard let url = URL(string: String(link)) else {
                return .failure(.invalidURL)
            }
            let request = URLRequest(url: url)
            return try await performRequest(with: model, request)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
        
    internal func performRequest<T: Codable>(with modelType: T.Type, _ urlRequest: URLRequest) async throws -> Result<T?, NetworkError> {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse)
            }
            let result = try decode(type: modelType, from: data)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
    
    private func decode<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
}
