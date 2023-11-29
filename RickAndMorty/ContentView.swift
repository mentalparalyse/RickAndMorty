//
//  ContentView.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            CharactersCarouselView(
                displayedData: $viewModel.displayableData,
                selection: $viewModel.selection,
                scrollOffset: $scrollOffset
            )
            CharactersListView(
                displayableData: $viewModel.displayableData,
                searchResults: $viewModel.searchDataResults,
                searchText: $viewModel.searchText,
                offset: $scrollOffset
            )
        }
        .background(
            Color.black
                .opacity(0.4)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

extension ContentView {
    struct CharactersListView: View {
        @Binding var displayableData: [DisplayedData]
        @Binding var searchResults: [DisplayedData]
        @Binding var searchText: String
        @Binding var offset: CGFloat
        
        var body: some View {
            VStack {
                searchBarView
                ScrollViewOffset(offset: $offset) {
                    createCharactersStack(for: searchText.isEmpty ? displayableData : searchResults)
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .background(Color.white)
        }
        
        @ViewBuilder
        private func createCharactersStack(for data: [DisplayedData]) -> some View {
            VStack(spacing: 10) {
                ForEach(data, id: \.id) { model in
                    ListCellView(displayedData: model)
                    Divider()
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
                        AsyncImage(urlString: character.imageUrl ?? "")
                            .frame(height: 200)
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

struct ContentView_Previews: PreviewProvider {
    static let stubService = NetworkService()
    static var previews: some View {
        ZStack {
            Color.black.opacity(0.4)
            ContentView(viewModel: .init(stubService))
        }
    }
}


extension View {
    var screenSize: CGSize {
        UIScreen.main.bounds.size
    }
}
