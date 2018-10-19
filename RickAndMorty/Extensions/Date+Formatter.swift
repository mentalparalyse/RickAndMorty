//
//  Date+Formatter.swift
//  RickAndMorty
//
//  Created by Lex Sava on 9/29/18.
//  Copyright © 2018 Lex Sava. All rights reserved.
//

import Foundation

extension Date {
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: self)
  }
}




