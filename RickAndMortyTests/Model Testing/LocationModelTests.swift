//
//  LocationModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 11/13/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import XCTest
import ObjectMapper

final class LocationModelTests: XCTestCase {

    private var data: Data?
    
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: type(of: self))
        
        if let url = bundle.url(forResource: "LocationJSON", withExtension: "json"){
            self.data = try? Data(contentsOf: url)
        }
    }
    
    override func tearDown() {
        data = nil
        super.tearDown()
    }
    
    
    func testLocationMapping(){
        guard let jsonData = self.data else {
            XCTAssert(false, "Something is wrong with json")
            return
        }
        
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: [])

        
        guard let locationModel = Mapper<LocationModel>().map(JSONObject: json) else {
            XCTAssert(false, "YOOOU")
            return
        }
        
        XCTAssertEqual(locationModel.info?.count, 394)
        XCTAssertEqual(locationModel.info?.pages, 20)
        XCTAssertEqual(locationModel.info?.next, "https://rickandmortyapi.com/api/location?page=2")
        XCTAssertEqual(locationModel.info?.prev, "")
        XCTAssertEqual(locationModel.results.count, 1)
        
    }
    

}
