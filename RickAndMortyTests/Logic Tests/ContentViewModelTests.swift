//
//  ContentViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 21.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class ContentViewModelTests: XCTestCase {

    var viewModel: ContentViewModel<StubCoordinator>!
    var servicesContainer: ServicesContainerProtocol!
    private let bag = CancelBag()
  
    func test_observers_setup() {
        servicesContainer = StubServicesContainer()
        viewModel = ContentViewModel(servicesContainer)
        let searchExpectation = expectation(description: "Search text updated")
        let listSelection = expectation(description: "List selection updated")
        
        viewModel.$selection.sink { _ in
            listSelection.fulfill()
        }
        .store(in: bag)
        viewModel.$searchText.sink { _ in
            searchExpectation.fulfill()
        }
        .store(in: bag)
        
        viewModel.setupObservers()
        waitForExpectations(timeout: 1.0)
    }
    
    func test_models_load_failure() {
        let expectation = expectation(description: "Expected models load fail")
        servicesContainer = StubServicesContainer(.failure(NetworkError.invalidResponse), .failure(.invalidResponse))
        viewModel = .init(servicesContainer)
        
        viewModel.loadModels(CharacterResultsModel.self, .character) { model in
            return model.results.compactMap { .init(character: $0) }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak viewModel] in
            XCTAssertTrue(viewModel?.searchDataResults.isEmpty == true)
            XCTAssertTrue(viewModel?.displayableData.isEmpty == true)
            XCTAssertTrue(viewModel?.responseInfo == nil)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func test_success_load() {
        let expectation = expectation(description: "Expected succesful models load")
        guard let data = loadData() else {
            return XCTFail("Unable to retrieve local data")
        }
        
        servicesContainer = StubServicesContainer(.success, .success(data))
        viewModel = .init(servicesContainer)
        
        viewModel.loadModels(CharacterResultsModel.self, .character) { model in
            return model.results.map { .init(character: $0) }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak viewModel] in
            XCTAssertEqual(viewModel?.displayableData.count, 1)
            XCTAssertEqual(viewModel?.responseInfo?.pages, 20)
            XCTAssertEqual(viewModel?.searchDataResults.count, 1)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    //TODO: Add error handler tests (when errors must be shown as a new root path)
    
    func loadData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "CharacterModel", withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}
