//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/25/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit
import Nuke


final class CharacterCell: UICollectionViewCell {
  @IBOutlet private weak var characterImageView: UIImageView!
  @IBOutlet private var characterDescription: [UILabel]!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    characterImageView.roundImage(width: 20, height: 20)
    characterImageView.clipsToBounds = true
  }
  
  
  public func initialize(from cellConfig: CellConfig){
    characterDescription[0].text = cellConfig.name
    let createdString = timeAgoSinceDate(cellConfig.created)
    let idString = "id: \(cellConfig.id) - created \(createdString)"
    characterDescription[1].text = idString
    if let imageUrl = URL(string: cellConfig.imageUrl) {
      Nuke.loadImage(with: imageUrl, into: characterImageView)
    }
  }
}

extension CharacterCell: ReusableView{
  static var nib: UINib {
    return UINib(nibName: "CharacterCell", bundle: nil)
  }
  
  static var reuseId: String {
    return "characterCell"
  }
}
