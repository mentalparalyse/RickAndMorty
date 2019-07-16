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

extension ReusableView{
  static var nib: UINib{
    return UINib(nibName: "\(self)", bundle: nil)
  }
  
  static var reuseId: String {
    return "\(self)"
  }
}

extension UICollectionView {
  func register<Cell: UICollectionViewCell>(cellType: Cell.Type) {
      self.register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseId)
  }
  
  func dequeueReusableCell<Cell: UICollectionViewCell>(type: Cell.Type,
                                                       indexPath: IndexPath) -> Cell {
    return self.dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
  }
}
extension UIView: ReusableView {}

