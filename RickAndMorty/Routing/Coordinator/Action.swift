//
//  Action.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import Foundation

protocol CoordinatorAction {}

enum Action: CoordinatorAction {
    case cancel(Any)
    case done(Any)
}
