//
//  NetworkServiceStub.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation
@testable import RickAndMorty

class StubJSONDecoder: DataDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        do {
            let decoder = JSONDecoder()
            let value = try decoder.decode(type, from: data)
            return value
        } catch {
            throw NetworkError.decodingError
        }
    }
}

final class StubNetworkService: NetworkServiceProtocol {
    enum Scenarios {
        case failure(NetworkError)
        case success(Data?)
        case realtime
    }
    
    let decoder: DataDecoderProtocol!
    let scenario: Scenarios
    init(_ sceanrio: Scenarios) {
        self.decoder = StubJSONDecoder()
        self.scenario = sceanrio
    }
    
    func load<T, U>(model: T.Type, link: U) async -> Result<T?, NetworkError> where T: Codable, U: StringProtocol {
        switch scenario {
        case .failure(let error):
            return .failure(error)
        case .success(let data):
            do {
                if let data {
                    let value = try decoder.decode(model, from: data)
                    return .success(value)
                }
                return .failure(.decodingError)
            } catch {
                return .failure(.decodingError)
            }
        case .realtime:
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
    }
    func performRequest<T: Codable>(with modelType: T.Type, _ urlRequest: URLRequest) async throws -> Result<T?, NetworkError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(.invalidResponse)
            }
            let result = try decoder.decode(modelType, from: data)
            return .success(result)
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
