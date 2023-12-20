//
//  CharacterModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation
import XCTest
@testable import RickAndMorty

class CharacterModelTests: XCTestCase, ModelsTestableProtocol {
    var mapper: DataDecoderProtocol!
    
    override func setUp() {
        mapper = JSONDecoderWrapper()
    }
    
    override func tearDown() {
        mapper = nil
    }
    
    func test_with_valid_json_successfully_decodes() {
        guard let data = fetchFileData(for: .character) else {
            return XCTFail("Character data cannot be fetched, check the method")
        }
        XCTAssertNoThrow(try mapper.decode(CharacterResultsModel.self, from: data), "Mapper shouldn't throw error")
        let characterResultModel = try? mapper.decode(CharacterResultsModel.self, from: data)
        XCTAssertNotNil(characterResultModel, "Character model shouldn't be nil")
        XCTAssertEqual(characterResultModel?.results.count, 1)
        XCTAssertEqual(characterResultModel?.info?.pages, 20)
        
        let character = characterResultModel?.results.first
        XCTAssertEqual(character?.name, "Rick Sanchez")
        XCTAssertEqual(character?.species, "Human")
        XCTAssertEqual(character?.status, "Alive")
        XCTAssertNotNil(character?.imageUrl, "Rick has it's image inside.")
    }
    
    func test_with_missing_data_error_thrown() {
        XCTAssertThrowsError(try mapper.decode(CharacterResultsModel.self, from: .init()))
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
    
    func test_with_invalid_json_error_throw() {
        guard let data = fetchFileData(for: .character) else {
            return XCTFail("Character data cannot be fetched, check the method")
        }
        XCTAssertThrowsError(try mapper.decode(LocationResultsModel.self, from: data))
        do {
            _ = try mapper.decode(LocationResultsModel.self, from: .init())
        } catch {
            guard let decoderError = error as? NetworkError else {
                XCTFail("This is wrong error type here")
                return
            }
            XCTAssertEqual(decoderError.localizedDescription, NetworkError.decodingError.localizedDescription)
        }
    }
}
