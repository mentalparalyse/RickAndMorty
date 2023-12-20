//
//  Color+Extensions.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI

public extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.init(.sRGB, red: red / 255, green: green / 255, blue: blue / 255, opacity: alpha)
    }
}
