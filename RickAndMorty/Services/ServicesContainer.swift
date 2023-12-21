//
//  ServicesContainer.swift
//  RickAndMorty
//
//  Created by Lex Sava on 13.12.2023.
//

import Foundation

protocol ServicesContainerProtocol {
    var networkService: NetworkServiceProtocol { get }
    var imageLoaderService: ImageLoaderProtocol { get }
    var imageCacherService: ImageCacherProtocol { get }
}

struct ServicesContainer: ServicesContainerProtocol {
    var imageCacherService: ImageCacherProtocol
    var imageLoaderService: ImageLoaderProtocol
    var networkService: NetworkServiceProtocol
    
    init(
        imageCacherService: ImageCacherProtocol,
        imageLoaderService: ImageLoaderProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.imageCacherService = imageCacherService
        self.imageLoaderService = imageLoaderService
        self.networkService = networkService
    }
}
