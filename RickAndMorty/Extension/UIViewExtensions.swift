//
//  UIViewExtensions.swift
//  RickAndMorty
//
//  Created by Lex Sava on 7/8/19.
//  Copyright © 2019 Lex Sava. All rights reserved.
//

import UIKit

extension UIView{
  internal func addSubviews(_ views: UIView...){
    views.forEach{
      self.addSubview($0)
    }
  }
}


