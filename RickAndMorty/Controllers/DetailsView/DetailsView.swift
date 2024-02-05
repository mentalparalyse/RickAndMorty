//
//  DetailsView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 25.01.2024.
//

import SwiftUI

struct DetailsView: View {
    @State private var model: CharacterModel = .mock
    
    var body: some View {
        ZStack {
            
            content
                .overlay(alignment: .topTrailing) {
                    closeButton
                }
        }
    }
}

extension DetailsView {
    var closeButton: some View {
        Button(action: {
            
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 17, weight: .bold))
                .shadow(color: .black.opacity(0.35), radius: 1, x: 1, y: 1)
                .foregroundColor(.white)
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [.init(hex: 0x1B8731), .init(hex: 0x84DB52)], 
                startPoint: .trailing,
                endPoint: .leading
            )
        )
        .clipShape(Circle())
        .offset(x: -14, y: -10)
        .shadow(color: .black.opacity(0.35), radius: 1, x: 0, y: 2)
        
    }
    var descriptionView: some View {
        mainDescription
    }
    
    var mainDescription: some View {
        VStack(alignment: .leading) {
            Text(model.name)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(Color.init(hex: 0x23CE3E))
                .minimumScaleFactor(0.5)
            characterStatusView
            locationDescriptionView
        }
    }
    
    var locationDescriptionView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Last known location:")
                .foregroundStyle(Color(hex: 0x8F8F8F))
                .font(
                    .system(size: 16, weight: .light)
                )
            Text(model.location.name)
                .foregroundStyle(Color(hex: 0xF1F1F1))
                .font(
                    .system(size: 18, weight: .bold, design: .monospaced)
                )
        }
    }
    
    var seenInEpisodeView: some View {
        VStack {
            Text("Last known location:")
                .foregroundStyle(Color(hex: 0x8F8F8F))
                .font(
                    .system(size: 16, weight: .light)
                )
            Text(model.location.name)
                .foregroundStyle(Color(hex: 0xF1F1F1))
                .font(
                    .system(size: 18, weight: .bold, design: .monospaced)
                )
        }
    }

    var characterStatusView: some View {
        HStack {
            Color(hex: CharacterStatus.alive.statusColor)
                .clipShape(Circle())
                .frame(width: 10, height: 10)
            Text("\(model.status) - " + "\(model.species)")
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .foregroundStyle(Color(hex: 0xF1F1F1))
        }
    }
    
    
    var content: some View {
        VStack(alignment: .leading) {
            imageView
                .clipShape(RoundedRectangle(cornerRadius: 32))
            descriptionView
        }
        .padding(16)
        .background(
            Color(hex: 0x27272C)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .shadow(color: .init(hex: 0x269035), radius: 5, x: 2, y: 2)
        )
        .padding(.horizontal, 20)
        
    }

    var imageView: some View {
        AsyncImage(cacher: ImageCacher(), urlString: model.imageUrl)
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.init(hex: 0x31353), .init(hex: 0x344444), .init(hex: 0x434333)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        Color.clear
            .background(.thinMaterial)
            .opacity(0.5)
        DetailsView()
        
    }

}
