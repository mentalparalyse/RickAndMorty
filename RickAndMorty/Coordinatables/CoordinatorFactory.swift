//
//  CoordinatorFactory.swift
//  RickAndMorty
//
//  Created by Lex Sava on 15.12.2023.
//

import SwiftUI

@MainActor
protocol CoordinatorFactoryProtocol {
    func makeSplashScreenCoordinator(_ parent: CoordinatorProtocol) -> SplashCoordinator
    func makeDataListCoordinator(_ parent: CoordinatorProtocol) -> DataListCoordinator
}
