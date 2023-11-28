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
    func loadData<T: Codable>(model: T.Type, link: AccessLinks) async -> T?
    func loadNextData<T: Codable>(model: T.Type, link: String) async -> T?
    func load<T: Codable>(model: T.Type, url link: AccessLinks) async -> AnyPublisher<Result<T, NetworkError>, Never>
    func load<T: ResponseModelProtocol>(for selection: ListSelection, url link: AccessLinks) async -> AnyPublisher<Result<T, NetworkError>, Never>
}

class NetworkErrorHandler {
    static func handle<T: Codable>(_ error: NetworkError) -> AnyPublisher<Result<T, NetworkError>, Never> {
        Just(Result.failure(error)).eraseToAnyPublisher()
    }
}


class NetworkService: NetworkServiceProtocol {
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
    
    func loadData<T: Codable>(model: T.Type, link: AccessLinks) async -> T? {
        do {
            let url = link.createURL()
            let request = URLRequest(url: url)
            let urlResponse = try await session.data(for: request)
            return try decode(type: model, from: urlResponse)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    func load<T: ResponseModelProtocol>(for selection: ListSelection, url link: AccessLinks) async -> AnyPublisher<Result<T, NetworkError>, Never> {
        var modelType: T.Type = switch selection {
        case .characters:
             CharacterResultsModel.self as! T.Type
        case .locations:
             LocationResultsModel.self as! T.Type
        case .episode:
             EpisodeModelResult.self as! T.Type
        }
        return await load(model: modelType, url: link)
    }
    
    func load<T: Codable>(model: T.Type, url link: AccessLinks) async -> AnyPublisher<Result<T, NetworkError>, Never> {
        return session.dataTaskPublisher(for: link.createURL())
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .map {
                Result.success($0)
            }
            .catch { error -> AnyPublisher<Result<T, NetworkError>, Never> in
                NetworkErrorHandler.handle(.decodingError(error))
            }
            .eraseToAnyPublisher()
    }
    
    func loadNextData<T: Codable>(model: T.Type, link: String) async -> T? {
        do {
            guard let url = URL(string: link) else { return nil }
            let request = URLRequest(url: url)
            let urlResponse = try await session.data(for: request)
            return try decode(type: model, from: urlResponse)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func decode<T: Decodable>(type: T.Type, from urlResponse: Response) throws -> T {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: urlResponse.data)
            return result
        }
    }
}
