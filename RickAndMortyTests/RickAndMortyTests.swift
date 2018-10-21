//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import XCTest
import RxSwift

@testable import RickAndMorty

final class RickAndMortyTests: XCTestCase {
  
  private let bag = DisposeBag()
  
  func testDateConversionNotNil(){
    let dateString = "2017-11-04T18:48:46.250Z"
    let date = timeAgoSinceDate(dateString)

    XCTAssertEqual(date, "11 months ago")
  }

  
  func testCallBacks(){
    let characters = getCharacters()
    let expectationDescription = expectation(description: "Character service callback called")
    
    characters.asObservable().subscribe(onNext: { model in
      let character: CharacterModel?
      character = model
      XCTAssertTrue(character != nil)
      expectationDescription.fulfill()
    }, onError: { (error) in
      
    }, onCompleted: {
  
    }).disposed(by: bag)
    
    waitForExpectations(timeout: 1) { (error) in
      if let error = error{
        XCTFail("expectation with time out: \(error)")
      }
    }
  }
  
  
  
  
  func testModelToNil(){
    let charactersObservable = getCharacters()
    var name: String?
    
    charactersObservable.asObservable()
      .subscribe(onNext: { (model) in
      let ricksName = model.characterInfo[0].characterInfo.name
      name = ricksName
      XCTAssertEqual("Rick Sanchez", name)
    }).disposed(by: bag)
  }
  
  
  
  
  func testCharacterDescription(){
    let charactersObservable = getCharacters()
    var description: [CharacterModel.Results]?
    
    charactersObservable.asObservable()
      .subscribe(onNext: { (model) in
      let ricksDescription = model.characterInfo
      description = ricksDescription
      XCTAssertNotNil(description)
    }).disposed(by: bag)
  }
  
  
  private func getCharacters() -> Observable<CharacterModel>{
    let request = CharacterRequest()
    let link = Links.charactersLink!
    let observableCharacters = request.getCahactersAsObservable(link)
    return observableCharacters
  }
  
}
