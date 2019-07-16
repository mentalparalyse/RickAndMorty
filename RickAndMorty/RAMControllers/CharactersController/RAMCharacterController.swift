//  RAMCharacterController.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RAMCharacterController: UIViewController {
  private let disposeBag = DisposeBag()
  
  public weak var coordinator: CharacterCoordinator?
  
  private lazy var charactersCollection: UICollectionView = {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 5
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
    let width = self.view.bounds.width - 30 /* harcoded value for now */
    let height = self.view.bounds.height / 2
    layout.itemSize = CGSize(width: width, height: height)
    let cv = UICollectionView(frame: .zero,
                              collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = .lightGray
    return cv
  }()
  
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let av = UIActivityIndicatorView(frame: .zero)
    av.style = .white
    av.hidesWhenStopped = true
    av.translatesAutoresizingMaskIntoConstraints = false
    return av
  }()
  
  static let startingOffset: CGFloat = 20.0
  
  static func nearOrBottom(contentOffset: CGPoint,
                           collection: UICollectionView) -> Bool{
    return contentOffset.y + collection.frame.size.height + startingOffset >= collection.contentSize.height
  }
  
  private var nextPageLoading: PublishRelay<Bool> = .init()
  
  private let characterPresenter: CharacterPresenter = {
    return CharacterPresenter(characterService: CharacterRequest())
  }()
  
  private var behaviourRelayData: BehaviorRelay<[CharacterViewData]> = {
    return BehaviorRelay(value: [])
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubviews(activityIndicator, charactersCollection)
    self.pinCollectionView()
    self.pinIndicatorView()
    self.registerCells()
    self.detectScroll()
    self.inspectIncomingCharacters()
    self.actOnSelected()
    
    coordinator?.prefersLargeTitle(true)
    
    characterPresenter.attachView(self)
    characterPresenter.getObservableCharacters()
  }
}

extension RAMCharacterController: CharacterView{
  internal func setCharacters(_ characters: [CharacterViewData]) {
    behaviourRelayData.accept(characters)
  }
  
  internal func loadNextCharacters(_ characters: [CharacterViewData]) {
    behaviourRelayData.accept(behaviourRelayData.value + characters)
  }
  
  internal func startAnimating() {
    activityIndicator.startAnimating()
  }
  
  internal func stopAnimating() {
    activityIndicator.stopAnimating()
  }
  
  internal func setEmptyCharacter() {
    print("Empty")
  }
}

//MARK:- CellSelection
extension RAMCharacterController{
  private func actOnSelected(){
    charactersCollection.rx
      .modelSelected(CharacterViewData.self)
      .bind { [weak coordinator] in
        coordinator?.showDetailCharacter($0)
      }.disposed(by: disposeBag)
  }
}

//MARK:- Characters Comes right here
extension RAMCharacterController{
  private func inspectIncomingCharacters(){
    behaviourRelayData
      .bind(to: charactersCollection.rx.items(cellIdentifier: CharacterCell.reuseId,
                                              cellType: CharacterCell.self))
      { index, viewData, cell in
        let config = CellConfig(name: viewData.name, id: viewData.id,
                                imageUrl: viewData.imageURL,
                                created: viewData.created)
        cell.initialize(from: config)
      }.disposed(by: disposeBag)
  }
}

/*
 MARK:- CollectionView bottom scroll detection
 Used for load next page characters
 */
extension RAMCharacterController{
  private func detectScroll(){
    charactersCollection
      .rx
      .contentOffset
      .map {
        return RAMCharacterController.nearOrBottom(contentOffset: $0,
                                                   collection: self.charactersCollection)
      }
      .bind(to: self.nextPageLoading)
      .disposed(by: disposeBag)
    
    nextPageLoading
      .skip(1)
      .subscribe(onNext: { [weak characterPresenter] loadNext in
      guard loadNext else { return }
      characterPresenter?.loadMoreCharacters()
      }, onError: { error in
        print(error.localizedDescription, "Error occured")
    }).disposed(by: disposeBag)
  }
}

//MARK:- cell registration
extension RAMCharacterController{
  private func registerCells(){
    charactersCollection.register(cellType: CharacterCell.self)
  }
}

//MARK:- Activity Pining
extension RAMCharacterController{
  func pinIndicatorView(){
    activityIndicator.snp.makeConstraints { maker in
      maker.center.equalToSuperview()
      maker.size.equalTo(40)
    }
  }
}

//MARK:- CollectionView Pining
extension RAMCharacterController{
  private func pinCollectionView(){
    charactersCollection.snp.makeConstraints { maker in
      maker.center.equalToSuperview()
      maker.size.equalToSuperview()
    }
  }
}
