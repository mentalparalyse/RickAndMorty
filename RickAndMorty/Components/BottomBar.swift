//
//  BottomBar.swift
//  RickAndMorty
//
//  Created by Lex Sava on 25.01.2024.
//

import SwiftUI

struct BottomBar<Item: Hashable, Content: View>: View {
    var items: [Item]
    @Binding var currentItem: Item
    @ViewBuilder var buttonContent: ((Item) -> Content)
    
    var body: some View {
        HStack {
            Spacer(minLength: 24)
            ForEach(items, id: \.self) { item in
                Spacer()
                buttonContent(item)
                    .foregroundColor(getColor(for: item))
                    .animation(.smooth, value: currentItem == item)
                    .onTapGesture {
                        guard currentItem != item else { return }
                        currentItem = item
                    }
                    .padding(.top, 7)
                Spacer()
            }
            Spacer(minLength: 24)
        }
        .background(Color(hex: 0x27272C))
        .shadow(color: .black.opacity(0.3), radius: 1)
    }
    
    private func getColor(for item: Item) -> Color {
        currentItem == item ? .green : .white
    }
}
