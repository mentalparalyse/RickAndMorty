//  RAMCharacterController.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/24/18.
//  Copyright © 2018 Lex Sava. All rights reserved.

import UIKit
import RxSwift
import RxCocoa

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
  
  private var nextPageLoading = false
  
  private let characterPresenter: CharacterPresenter = {
    return CharacterPresenter(characterService: CharacterRequest())
  }()
  
  private var behaviourRelayData: BehaviorRelay<[CharacterViewData]> = {
    return BehaviorRelay(value: [])
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(activityIndicator)
    self.view.addSubview(charactersCollection)
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
    let index = charactersCollection.rx.itemSelected
    index.subscribe(onNext: { (indexPath) in
      let item = indexPath.item
      let detailedData = self.behaviourRelayData.value[item]
      self.coordinator?.showDetailCharacter(detailedData)
    }).disposed(by: disposeBag)
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
      .subscribe {
        if RAMCharacterController
          .nearOrBottom(contentOffset: $0.element!,
                        collection: self.charactersCollection){
          if self.nextPageLoading{
            self.characterPresenter.loadMoreCharacters()
            self.nextPageLoading = false
          }
        }else{
          self.nextPageLoading = true
        }
      }.disposed(by: disposeBag)
  }
}

//MARK:- cell registration
extension RAMCharacterController{
  private func registerCells(){
    let cell = CharacterCell.self
    charactersCollection.register(cellType: cell)
  }
}

//MARK:- Activity Pining
extension RAMCharacterController{
  func pinIndicatorView(){
    NSLayoutConstraint(item: activityIndicator, attribute: .centerX,
                       relatedBy: .equal, toItem: view,
                       attribute: .centerX, multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: activityIndicator, attribute: .centerY,
                       relatedBy: .equal, toItem: view,
                       attribute: .centerY, multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: activityIndicator, attribute: .height,
                       relatedBy: .equal, toItem: nil,
                       attribute: .height, multiplier: 1,
                       constant: 40).isActive = true
    
    NSLayoutConstraint(item: activityIndicator, attribute: .width,
                       relatedBy: .equal, toItem: nil,
                       attribute: .width, multiplier: 1,
                       constant: 40).isActive = true
  }
}

//MARK:- CollectionView Pining
extension RAMCharacterController{
  private func pinCollectionView(){
    NSLayoutConstraint(item: charactersCollection, attribute: .top,
                       relatedBy: .equal, toItem: view,
                       attribute: .top, multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: charactersCollection, attribute: .bottom,
                       relatedBy: .equal, toItem: view,
                       attribute: .bottom, multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: charactersCollection, attribute: .leading,
                       relatedBy: .equal, toItem: view,
                       attribute: .leading, multiplier: 1,
                       constant: 0).isActive = true
    
    NSLayoutConstraint(item: charactersCollection, attribute: .trailing,
                       relatedBy: .equal, toItem: view,
                       attribute: .trailing, multiplier: 1,
                       constant: 0).isActive = true
  }
}
