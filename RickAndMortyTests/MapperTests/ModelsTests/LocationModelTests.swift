//
//  LocationModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation
import XCTest
@testable import RickAndMorty

class LocationModelTests: XCTestCase, ModelsTestableProtocol {
    var mapper: DataDecoderProtocol!
    
    override func setUp() {
        mapper = JSONDecoderWrapper()
    }
    
    override func tearDown() {
        mapper = nil
    }
    
    func test_with_valid_json_successfully_decodes() {
        guard let data = fetchFileData(for: .location) else {
            return XCTFail("Location data cannot be fetched, check the method, filename: \(ModelTypes.location.modelName)")
        }
        XCTAssertNoThrow(try mapper.decode(LocationResultsModel.self, from: data))
        let locationResult = try? mapper.decode(LocationResultsModel.self, from: data)
        XCTAssertEqual(locationResult?.info?.count, 126)
        XCTAssertEqual(locationResult?.info?.pages, 7)
        
        XCTAssertEqual(locationResult?.results.count, 1)
        XCTAssertEqual(locationResult?.info?.pages, 7)
        XCTAssertEqual(locationResult?.results[0].name, "Earth")
        XCTAssertEqual(locationResult?.results[0].type, "Planet")
        XCTAssertEqual(locationResult?.results[0].residents.count, 2)
        XCTAssertEqual(locationResult?.results[0].dimension, "Dimension C-137")
    }
    
    func test_with_invalid_json_error_throw() {
        guard let data = fetchFileData(for: .location) else {
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
    
    func test_location_custom_initialization() {
        let location = LocationModel(id: 0, 
                                     name: "Earth",
                                     type: "Planet",
                                     dimension: "Dimension C-137",
                                     residents: [])
        XCTAssertEqual(location.id, 0)
        XCTAssertEqual(location.name, "Earth")
        XCTAssertEqual(location.type, "Planet")
        XCTAssertEqual(location.dimension, "Dimension C-137")
        XCTAssertTrue(location.residents.isEmpty)
    }
    
}
