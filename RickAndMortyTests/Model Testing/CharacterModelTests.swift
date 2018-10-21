//
//  CharacterModelTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 10/21/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import XCTest
import ObjectMapper

final class CharacterModelTests: XCTestCase {
  
  private var data: Data?
  
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: type(of: self))
    
    if let url = bundle.url(forResource: "CharacterJSON", withExtension: "json"){
      self.data = try? Data(contentsOf: url)
    }
  }
  
  override func tearDown() {
    data = nil
    super.tearDown()
  }
  
  
  func testMapping(){
    guard let jsonData = self.data else {
        XCTAssert(false, "Something is wrong with json")
        return
    }

    let JSON = try! JSONSerialization.jsonObject(with: jsonData, options: [])
    
    guard let character = Mapper<CharacterModel>().map(JSONObject: JSON) else {
      XCTAssert(false, "Shit happens")
      return
    }
    
    XCTAssertEqual(character.info?.count, 394)
    XCTAssertEqual(character.info?.pages, 20)
    XCTAssertEqual(character.info?.next, "https://rickandmortyapi.com/api/character/?page=2")
    XCTAssertEqual(character.info?.prev, "")
    XCTAssertEqual(character.characterInfo.count, 1)
    
  }
}
