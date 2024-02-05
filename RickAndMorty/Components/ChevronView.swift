//
//  ChevronView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 25.01.2024.
//

import SwiftUI

struct ChevronView: View {
    @State private var chevronAnimationValue = false
    var onTapAction: () -> Void
    
    var body: some View {
        Image(systemName: "chevron.forward")
            .rotationEffect(.degrees(chevronAnimationValue ? -90 : 90),
                            anchor: .center)
            .animation(.smooth.speed(2), value: chevronAnimationValue)
            .font(.system(size: 24, design: .rounded))
            .foregroundStyle(Color.white)
            .padding(.trailing, 10)
            .onTapGesture {
                onTapAction()
                chevronAnimationValue.toggle()
            }
    }
}

#Preview {
    ChevronView { }
}
