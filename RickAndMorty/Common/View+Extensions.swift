//
//  View+Extensions.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

extension View {
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
                    .zIndex(2)
            }
            self
        }
    }
    
    @ViewBuilder
    func ifLet<T, Content: View>(_ value: T?, modifier: (Self, T) -> Content) -> some View {
        if let value = value {
            modifier(self, value)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
