//
//  NetworkService.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

enum AccessLinks: String {
    case character = "character"
    case location = "location"
    case episode = "episode"
    
    func createURL() -> URL {
        guard let baseUrl = URL(string: "https://rickandmortyapi.com/api/") else {
            fatalError("Link cannot be formated.")
        }
        return baseUrl.appendingPathComponent(rawValue)
    }
}

protocol NetworkServiceProtocol {
    func loadData<T: Codable>(model: T.Type, link: AccessLinks) async -> Result<T?, NetworkError>
    func loadNextData<T: Codable>(model: T.Type, link: String) async -> Result<T?, NetworkError>
}

class NetworkService: NetworkServiceProtocol {
    private var baseURL = URL(string: "https://rickandmortyapi.com/api/")
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 6
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
    
    typealias Response = (data: Data, response: URLResponse)
    
    func loadData<T: Codable>(model: T.Type, link: AccessLinks) async -> Result<T?, NetworkError> {
        do {
            guard let url = baseURL?.appendingPathComponent(link.rawValue) else {
                return .failure(.invalidURL)
            }
            let request = URLRequest(url: url)
            return try await send(with: model, request)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
    
    func loadNextData<T: Codable>(model: T.Type, link: String) async -> Result<T?, NetworkError> {
        do {
            guard let url = URL(string: link) else {
                return .failure(.invalidURL)
            }
            
            let request = URLRequest(url: url)
            return try await send(with: model, request)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
    
    private func send<T: Codable>(with modelType: T.Type, _ urlRequest: URLRequest) async throws -> Result<T?, NetworkError> {
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse)
            }
            let result = try decode(type: modelType, from: data)
            return result
        } catch {
            return .failure(.requestFailed(error))
        }
    }
    
    private func decode<T: Decodable>(type: T.Type, from data: Data) throws -> Result<T?, NetworkError> {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.decodingError(error))
        }
    }
}
