//
//  NetworkingTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import XCTest
@testable import RickAndMorty

final class NetworkingTests: XCTestCase {

    var sut: NetworkServiceProtocol!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_failure_scenario() async {
        let expectation = expectation(description: "Load should be failed")
        sut = StubNetworkService(.failure(.invalidResponse))
        let result = await sut.load(model: CharacterResultsModel.self,
                                        link: AccessLinks.character.initialLink)
        
        switch result {
        case .success(_):
            XCTFail("Expected failure, but got success")
        case .failure(let failure):
            XCTAssertEqual(failure.localizedDescription,
                           NetworkError.invalidResponse.localizedDescription)
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func test_success_scenario() async {
        let expectation = expectation(description: "Load should be success")
        let modelName = ModelTypes.character.modelName
        guard let url = Bundle(for: type(of: self)).url(forResource: modelName, withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
            expectation.fulfill()
            return XCTFail("Failed to retrieve data from bundle.")
        }
        sut = StubNetworkService(.success(data))
        
        let result = await sut.load(model: CharacterResultsModel.self, link: "example")
        
        switch result {
        case .success(let success):
            XCTAssertNotNil(success)
        case .failure(_):
            XCTFail("Expected success, but got failure")
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
    }

    func test_realtime_data_scenario() async {
        let expectation = expectation(description: "Load should be done in realtime")
        sut = StubNetworkService(.realtime)
        let result = await sut.load(model: CharacterResultsModel.self, link: AccessLinks.character.initialLink)
        
        switch result {
        case .success(let success):
            XCTAssertEqual(success?.info?.count, 826)
            XCTAssertEqual(success?.info?.pages, 42)
            XCTAssertEqual(success?.info?.next, "https://rickandmortyapi.com/api/character?page=2")
            XCTAssertEqual(success?.info?.prev, nil)
            XCTAssertEqual(success?.results.first?.name, "Rick Sanchez")
            XCTAssertEqual(success?.results.first?.gender, "Male")
            XCTAssertEqual(success?.results.first?.species, "Human")
            XCTAssertEqual(success?.results.first?.status, "Alive")
        case .failure(_):
            XCTFail("Expected success data")
        }
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5.0)
        
    }
    
}
