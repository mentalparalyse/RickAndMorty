//
//  SplashView.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import SwiftUI

struct SplashView<Coordinator: Routing>: View {
    
    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var viewModel = SplashViewModel<Coordinator>()
    
    var body: some View {
        Image(.splash)
            .resizable()
            .aspectRatio(1/1, contentMode: .fill)
            .frame(width: screenSize.width, height: screenSize.height)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.coordinator = coordinator
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    viewModel.showNextRoute()
                }
            }
    }
}

#Preview {
    let diContainer = DependencyContainer()
    let mockWindow = UIWindow()
    let appCoordinator = diContainer.makeAppCoordinator(mockWindow)
    let coordinator = diContainer.makeSplashScreenCoordinator(appCoordinator)
    return SplashView<SplashCoordinator>()
        .environmentObject(coordinator)
    
}
