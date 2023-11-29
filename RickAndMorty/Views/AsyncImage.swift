//
//  AsyncImage.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI
import Combine

struct AsyncImage: View {
    @StateObject private var imageLoader = ImageLoader()
    @State private var uiImage: UIImage?
    private let urlString: String
    private let contentMode: ContentMode
    
    init(urlString: String, contentMode: ContentMode = .fit) {
        self.urlString = urlString
        self.contentMode = contentMode
    }
    
    var body: some View {
        ZStack {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
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
            self.uiImage = uiImage
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in UIImage(data: data) }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] failure in
                self?.image = nil
            }, receiveValue: { [weak self] image in
                self?.image = image
            })
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
