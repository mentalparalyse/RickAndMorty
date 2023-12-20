//
//  SplashView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        Image("Splash")
            .resizable()
            .aspectRatio(1/1, contentMode: .fill)
            .frame(width: screenSize.width, height: screenSize.height)
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashView()
}
