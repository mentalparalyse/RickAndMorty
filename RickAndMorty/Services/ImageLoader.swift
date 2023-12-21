//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Lex Sava on 14.12.2023.
//

import Combine
import SwiftUI

protocol ImageLoaderProtocol {
    func loadImage(from url: URL)
    func cancel()
}

class ImageLoader: ObservableObject, ImageLoaderProtocol {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    private var cacher: ImageCacherProtocol
    
    init(_ cacher: ImageCacherProtocol) {
        self.cacher = cacher
    }
    
    func loadImage(from url: URL) {
        if let cachedImage = cacher.getImage(for: url.absoluteString) {
            image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response in UIImage(data: data) }
            .handleEvents(receiveCancel: { [weak self] in
                guard let self else { return }
                self.loadImage(from: url)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] failure in
                self?.image = nil
            }, receiveValue: { [weak self] image in
                self?.image = image
                if let image {
                    self?.cacher.setImage(image, for: url.absoluteString)
                }
            })
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}

protocol ImageCacherProtocol {
    var cache: NSCache<NSString, UIImage> { get }
    func getImage(for name: String) -> UIImage?
    func setImage(_ image: UIImage?, for name: String)
}

class ImageCacher: ObservableObject, ImageCacherProtocol {
    internal var cache: NSCache<NSString, UIImage> {
        .init()
    }
    
    func getImage(for name: String) -> UIImage? {
        cache.object(forKey: NSString(string: name))
    }
    
    func setImage(_ image: UIImage?, for name: String) {
        guard getImage(for: name) == nil, let image else { return }
        cache.setObject(image, forKey: NSString(string: name))
    }
}
