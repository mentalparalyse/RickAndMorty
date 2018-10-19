//
//  DetailCharacterView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 10/8/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import Nuke
import RxGesture
import RxSwift

final class DetailCharacterView: UIView {

  public var coordinator: Coordinator?
  private let bag = DisposeBag()
  
  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var characterImage: UIImageView!
  @IBOutlet private var characterDescription: [UILabel]!
  
  @IBOutlet private var characterDetails: [UILabel]!

  
  public var characterViewData: CharacterViewData? {
    didSet{
      initDetails()
    }
  }
  
  override func awakeFromNib() {
    super .awakeFromNib()
    self.swipeToRemove()
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.layoutIfNeeded()
    commonInitView()
  }
}

extension DetailCharacterView{
  
  private func swipeToRemove(){
    self.rx.swipeGesture([.down, .up]).when(.recognized).subscribe { _ in
      self.coordinator?.removeDetailView(self)
      }.disposed(by: bag)
  }
  
  private func initDetails(){
    guard let characterData = characterViewData else {
      return
    }
    let url = URL(string: characterData.imageURL)!
    Nuke.loadImage(with: url, into: characterImage)
    characterDescription[0].text = characterData.name
    let date = characterData.created
    let createdString = timeAgoSinceDate(date)
    let idString = "id: \(characterData.id) - created \(createdString)"
    characterDescription[1].text = idString
    
    self.initDetailedData(characterData)
  }
  
  private func initDetailedData(_ data: CharacterViewData){
    characterDetails[0].text = data.status
    characterDetails[1].text = data.species
    characterDetails[2].text = data.gender
    characterDetails[3].text = data.origin
    characterDetails[4].text = data.lastLocation
  }
  

  private func commonInitView(){
    characterImage.roundImage(width: 15, height: 15)
    characterImage.layer.masksToBounds = false
    characterImage.clipsToBounds = true
    contentView.layer.masksToBounds = true
    contentView.layer.cornerRadius = 15
  }
}
