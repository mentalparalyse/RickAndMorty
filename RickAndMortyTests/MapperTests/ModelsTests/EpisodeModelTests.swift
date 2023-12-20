//
//  EpisodeModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import XCTest
@testable import RickAndMorty

final class EpisodeModelTests: XCTestCase, ModelsTestableProtocol {
    var mapper: DataDecoderProtocol!
    
    override func setUp() {
        mapper = JSONDecoderWrapper()
    }
    
    override func tearDown() {
        mapper = nil
    }
    
    func test_with_valid_json_successfully_decodes() {
        guard let data = fetchFileData(for: .episode) else {
            return XCTFail("Character data cannot be fetched, check the method")
        }
        XCTAssertNoThrow(try mapper.decode(EpisodeModelResult.self, from: data), "Mapper shouldn't throw error")
        let episodeResultModel = try? mapper.decode(EpisodeModelResult.self, from: data)
        XCTAssertNotNil(episodeResultModel, "Character model shouldn't be nil")
        XCTAssertEqual(episodeResultModel?.results.count, 1)
        XCTAssertEqual(episodeResultModel?.info?.pages, 3)
        
        let episode = episodeResultModel?.results.first
        XCTAssertEqual(episode?.characters.count, 2)
        XCTAssertEqual(episode?.id, 1)
        XCTAssertEqual(episode?.name, "Pilot")
        XCTAssertEqual(episode?.episode, "S01E01")
    }
    
    func test_with_missing_data_error_thrown() {
        XCTAssertThrowsError(try mapper.decode(EpisodeModelResult.self, from: .init()))
        do {
            _ = try mapper.decode(EpisodeModelResult.self, from: .init())
        } catch {
            guard let decoderError = error as? NetworkError else {
                XCTFail("This is wrong error type here")
                return
            }
            XCTAssertEqual(decoderError.localizedDescription, NetworkError.decodingError.localizedDescription)
        }
    }
    
    func test_with_invalid_json_error_throw() {
        guard let data = fetchFileData(for: .episode) else {
            return XCTFail("Character data cannot be fetched, check the method")
        }
        XCTAssertThrowsError(try mapper.decode(CharacterResultsModel.self, from: data))
        do {
            _ = try mapper.decode(CharacterResultsModel.self, from: .init())
        } catch {
            guard let decoderError = error as? NetworkError else {
                XCTFail("This is wrong error type here")
                return
            }
            XCTAssertEqual(decoderError.localizedDescription, NetworkError.decodingError.localizedDescription)
        }
    }
    
    func test_custom_initialization() {
        let episode = EpisodeModel(id: 0, 
                                   name: "Pilot",
                                   airDate: "December",
                                   episode: "S01E01",
                                   characters: [])
        XCTAssertEqual(episode.id, 0)
        XCTAssertEqual(episode.name, "Pilot")
        XCTAssertEqual(episode.airDate, "December")
        XCTAssertEqual(episode.episode, "S01E01")
        XCTAssertTrue(episode.characters.isEmpty)
    }
    
}
