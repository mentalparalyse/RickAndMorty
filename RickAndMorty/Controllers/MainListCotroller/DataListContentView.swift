//
//  ContentView.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

struct ContentView<Coordinator: Routing>: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @StateObject var viewModel: ContentViewModel<Coordinator>
    @State private var scrollOffset: CGFloat = 0
    @State private var shouldLoadMore = false
    
    var body: some View {
        VStack {
            if viewModel.currentSelection == .character {
                CharactersCarouselView(
                    services: viewModel.services,
                    displayedData: $viewModel.displayableData,
                    selection: $viewModel.selection,
                    scrollOffset: $scrollOffset
                )
            }
            
            CharactersListView(
                services: viewModel.services,
                displayableData: $viewModel.displayableData,
                searchResults: $viewModel.searchDataResults,
                searchText: $viewModel.searchText,
                offset: $scrollOffset,
                shouldLoadMore: $shouldLoadMore
            )
        }
        .onChange(of: shouldLoadMore) {
            guard $0 else { return }
            viewModel.loadNext()
        }
        .background(
            Color(hex: 0x800080)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

extension ContentView {
    struct CharactersListView: View {
        var services: ServicesContainerProtocol
        @Binding var displayableData: [DisplayedData]
        @Binding var searchResults: [DisplayedData]
        @Binding var searchText: String
        @Binding var offset: CGFloat
        @Binding var shouldLoadMore: Bool
        
        var body: some View {
            VStack {
                searchBarView
                ScrollViewOffset(offset: $offset) {
                    createCharactersStack(for: searchText.isEmpty ? displayableData : searchResults)
                }
                .scrollDismissesKeyboard(.immediately)
            }
        }
        
        @ViewBuilder
        private func createCharactersStack(for data: [DisplayedData]) -> some View {
            LazyVStack(spacing: 10) {
                ForEach(data, id: \.id) { model in
                    ListCellView(displayedData: model, servicesContainer: services)
                        .onAppear {
                            shouldLoadMore = model.id == data.last?.id
                        }
                    Divider()
                        .overlay(Color(hex: 0xFFD700))
                }
            }
        }
        
        private var searchBarView: some View {
            TextField("", text: $searchText)
                .padding(7)
                .textFieldStyle(.roundedBorder)
                .placeholder(when: searchText.isEmpty, alignment: .center) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search by name")
                    }
                    .foregroundColor(.gray)
                }
                .background(Color.gray.opacity(0.55))
                .frame(height: 45)
                .onAppear {
                    UITextField.appearance().clearButtonMode = .whileEditing
                }
        }
    }
    
    struct CharactersCarouselView: View {
        var services: ServicesContainerProtocol
        @Binding var displayedData: [DisplayedData]
        @Binding var selection: Int
        @Binding var scrollOffset: CGFloat
        @State private var tabHeight: CGFloat = .zero
        
        private var maxHeight: CGFloat {
            return screenSize.height * 0.33
        }
        
        var body: some View {
            TabView(selection: $selection) {
                ForEach(displayedData, id: \.id) { character in
                    HStack {
                        if let characterURL = character.imageUrl {
                            AsyncImage(cacher: services.imageCacherService, urlString: characterURL)
                                .frame(height: 200)
                        }
                    }
                }
            }
            .opacity(tabHeight == 0 ? 0 : 1)
            .tabViewStyle(.page)
            .frame(width: screenSize.width)
            .frame(maxHeight: tabHeight)
            .onChange(of: scrollOffset) { offset in
                withAnimation {
                    if offset / maxHeight >= 1 {
                        tabHeight = 0
                    } else {
                        tabHeight = maxHeight
                    }
                }
            }
            .onAppear {
                tabHeight = maxHeight
            }
        }
    }
}
