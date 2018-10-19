//
//  UICollectioView+ReusableView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/29/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit


protocol ReusableView: class {
  static var nib: UINib { get }
  static var reuseId: String { get }
}

extension UICollectionView {
  func register<Cell: UICollectionViewCell>(cellType: Cell.Type)
    where Cell: ReusableView {
      self.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseId)
  }
  
  func dequeueReusableCell<Cell: UICollectionViewCell>(type: Cell.Type,
                                                       indexPath: IndexPath) -> Cell where Cell: ReusableView {
    return self.dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
  }
}

