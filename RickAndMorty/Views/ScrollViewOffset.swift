//
//  ScrollViewOffset.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI
import Combine
import SwiftUI
import UIKit

struct ScrollViewOffset<Content: View>: View {
    let content: () -> Content
    @Binding var offset: CGFloat
    
    init(
        offset: Binding<CGFloat>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self._offset = offset
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            offsetReader
            content()
                .padding(.top, -8)
        }
        .coordinateSpace(name: "frameLayer")
        .onPreferenceChange(OffsetPreferenceKey.self) { scrollOffset in
            Task.detached(priority: .userInitiated) { @MainActor in
                offset = scrollOffset
            }
        }
    }
    
    var offsetReader: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: OffsetPreferenceKey.self,
                    value: -proxy.frame(in: .named("frameLayer")).origin.y
                )
                .frame(height: 0)
        }
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}
