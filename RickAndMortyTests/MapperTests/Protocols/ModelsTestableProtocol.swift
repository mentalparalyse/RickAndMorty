//
//  ModelsTestableProtocol.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 19.12.2023.
//

import Foundation
import XCTest
@testable import RickAndMorty

protocol ModelsTestableProtocol: AnyObject {
    var mapper: DataDecoderProtocol! { get set }
    func test_with_valid_json_successfully_decodes()
    func test_with_missing_data_error_thrown()
    func test_with_invalid_json_error_throw()
    func fetchFileData(for modelType: ModelTypes) -> Data?
}

extension ModelsTestableProtocol {
    func test_with_missing_data_error_thrown() { }
    
    func fetchFileData(for modelType: ModelTypes) -> Data? {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.url(forResource: modelType.modelName, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        return nil
    }
}
