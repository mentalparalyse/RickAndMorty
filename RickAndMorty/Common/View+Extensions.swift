//
//  View+Extensions.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
                    .zIndex(2)//.opacity(shouldShow ? 1 : 0)
            }
            self
        }
    }
}
