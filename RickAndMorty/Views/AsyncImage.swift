//
//  AsyncImage.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI
import Combine

struct AsyncImage: View {
    @StateObject private var imageLoader: ImageLoader
    @State private var uiImage: UIImage?
    private let urlString: String
    private let contentMode: ContentMode
    
    init(cacher: ImageCacherProtocol, urlString: String, contentMode: ContentMode = .fit) {
        self.urlString = urlString
        self.contentMode = contentMode
        _imageLoader = .init(wrappedValue: .init(cacher))
//        self.imageLoader = .init(cacher)
    }
    
    var body: some View {
        ZStack {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .transition(.opacity.animation(.easeIn))
            } else {
                ProgressView()
                    .onAppear {
                        if let url = URL(string: urlString) {
                            imageLoader.loadImage(from: url)
                        }
                    }
            }
        }
        .onReceive(imageLoader.$image) { uiImage in
            guard let uiImage else { return }
            withAnimation {
                self.uiImage = uiImage
            }
        }
    }
}
