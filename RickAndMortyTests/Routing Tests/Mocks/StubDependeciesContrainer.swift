//
//  StubDependeciesContrainer.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import Foundation
import XCTest
@testable import RickAndMorty

enum ServiceScenarios {
    case failure(Error)
    case success
}

struct StubServicesContainer: ServicesContainerProtocol {
    var imageCacherService: ImageCacherProtocol
    var imageLoaderService: ImageLoaderProtocol
    var networkService: NetworkServiceProtocol

    init(_ scenario: ServiceScenarios = .success, 
         _ networkScenario: StubNetworkService.Scenarios = .realtime) {
        self.imageCacherService = StubImageCacher(scenario: scenario)
        self.imageLoaderService = StubImageLoader(scenario: scenario)
        self.networkService = StubNetworkService(networkScenario)
    }
}

class StubImageCacher: ImageCacherProtocol {
    var cache: NSCache<NSString, UIImage> {
        .init()
    }
    
    var scenario: ServiceScenarios
    
    init(scenario: ServiceScenarios) {
        self.scenario = scenario
    }
    
    func getImage(for name: String) -> UIImage? {
        nil
    }
    
    func setImage(_ image: UIImage?, for name: String) { 
        
    }
}

class StubImageLoader: ImageLoaderProtocol {
    var scenario: ServiceScenarios
    init(scenario: ServiceScenarios) {
        self.scenario = scenario
    }
    
    func cancel() {
        
    }
    func loadImage(from url: URL) { 
        
    }
}
