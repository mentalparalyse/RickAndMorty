//
//  ContentView.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

struct ContentView<Coordinator: Routing>: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var viewModel = ContentViewModel<Coordinator>()
    @State private var scrollOffset: CGFloat = 0
    @State private var shouldLoadMore = false
    
    var body: some View {
        VStack {
            CharactersListView(
                services: viewModel.services,
                displayableData: $viewModel.displayableData,
                offset: $scrollOffset,
                shouldLoadMore: $shouldLoadMore
            )
        }
        .overlay(alignment: .bottom) {
            BottomBar(
                items: AccessLinks.allCases,
                currentItem: $viewModel.currentSelection
            ) { item in
                VStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 28)
                    
                    Text(item.rawValue.capitalized + "s")
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear {
            viewModel.coordinator = coordinator
        }
        .onChange(of: shouldLoadMore) {
            guard $0 else { return }
            viewModel.loadNext()
        }
        .background(
            Color(hex: 0x27272C)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    let diContainer = DependencyContainer()
    let mockWindow = UIWindow()
    let appCoordinator = diContainer.makeAppCoordinator(mockWindow)
    let coordinator = diContainer.makeDataListCoordinator(appCoordinator)
    return ContentView<DataListCoordinator>(coordinator: .init(), viewModel: .init())
        .environmentObject(coordinator)
}
