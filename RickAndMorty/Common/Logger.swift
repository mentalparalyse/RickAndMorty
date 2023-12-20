//
//  Logger.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import OSLog

extension Logger {
    private static let subsystem = "Rick&Morty"
    
    static let coordinator = Logger(subsystem: subsystem, category: "Coordinator")
}
