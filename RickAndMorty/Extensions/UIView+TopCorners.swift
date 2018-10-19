//
//  UIView+TopCorners.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/28/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import UIKit

extension UIView{
  public func roundImage(width: CGFloat, height: CGFloat){
    let path = UIBezierPath(roundedRect: self.bounds,
                            byRoundingCorners: [.topRight, .topLeft],
                            cornerRadii: CGSize(width: width, height: height))
    let maskLayer = CAShapeLayer()
    maskLayer.frame = self.bounds
    maskLayer.path = path.cgPath
    self.layer.mask = maskLayer
  }
}
