//
//  NetworkService.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import Foundation

enum AccessLinks: String {
    case character = "character/"
    case location = "loction/"
    case episode = "episode"
    
    func createURL() -> URL {
        guard let baseUrl = URL(string: "https://rickandmortyapi.com/api/") else {
            fatalError("Link cannot be formated.")
        }
        return baseUrl.appendingPathComponent(rawValue)
    }
}

protocol HoldingResults {
    associatedtype R
    var results: [R] { get }
}

struct Response<T: Codable>: Codable {
    var results: [T]
}

extension Response: HoldingResults { }


protocol NetworkServiceProtocol {
    func loadData<T: Codable>(model: T.Type, link: AccessLinks) async -> T?
    func loadNextData<T: Codable>(model: T.Type, link: String) async -> T?
}

class NetworkService: NetworkServiceProtocol {
    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 6
//        configuration.requestCachePolicy = .returnCacheDataElseLoad
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
