//
//  ContentView.swift
//  TestTask
//
//  Created by iMac on 26.08.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var characters: [CharacterModel] = []
    @Published var locations: [LocationModel] = []
    @Published var searchCharacters: [CharacterModel] = []
    
    @Published private var charactersInfo: ResultInfo?
    
    @Published var searchText: String = ""
    @Published var selection: Int = 0
    
    private let bag = CancelBag()
    private let networkService: NetworkServiceProtocol
    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        updateData(AccessLinks.character.createURL().absoluteString)
        setupObservers()
    }
    
    func setupObservers() {
        $selection
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                guard let self else { return }
                if $0 == self.characters.count,
                   let nextPage = self.charactersInfo?.next,
                    searchText.isEmpty {
                    self.updateData(nextPage)
                }
            }
            .store(in: bag)
        
        $searchText
            .sink { [weak self] value in
                guard let self else { return }
                self.searchCharacters = self.results(for: value)
            }
            .store(in: bag)
    }
    
    private func results(for search: String) -> [CharacterModel] {
        searchCharacters = characters
        return searchCharacters.filter { $0.name.contains(search) }
    }
    
    
    private func updateData(_ pageLink: String) {
        Task.detached(priority: .high) { @MainActor [weak self] in
            guard let self else { return }
            let newCharacters = await self.networkService.loadNextData(
                model: CharacterResultsModel.self,
                link: pageLink
            )
            self.searchCharacters.append(contentsOf: newCharacters?.results ?? [])
            self.characters.append(contentsOf: newCharacters?.results ?? [])
            self.charactersInfo = newCharacters?.info
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            CharactersCarouselView(
                characters: $viewModel.characters,
                selection: $viewModel.selection,
                scrollOffset: $scrollOffset
            )
            CharactersListView(
                characters: $viewModel.characters,
                searchResults: $viewModel.searchCharacters,
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
        @Binding var characters: [CharacterModel]
        @Binding var searchResults: [CharacterModel]
        @Binding var searchText: String
        @Binding var offset: CGFloat
        
        var body: some View {
            VStack {
                searchBarView
                ScrollViewOffset(offset: $offset) {
                    createCharactersStack(for: searchText.isEmpty ? characters : searchResults)
                }
                .scrollDismissesKeyboard(.immediately)
            }
            .background(Color.white)
        }
        
        @ViewBuilder
        private func createCharactersStack(for data: [CharacterModel]) -> some View {
            ForEach(data, id: \.id) { character in
                createListCell(character)
                Divider()
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
        
        func createListCell(_ character: CharacterModel) -> some View {
            HStack {
                AsyncImage(urlString: character.imageUrl)
                    .frame(height: 30)
                    .cornerRadius(15)
                VStack(alignment: .leading) {
                    Text(character.name)
                    Text(character.gender)
                        .foregroundColor(.cyan) + Text(" " + character.status)
                        .foregroundColor(.yellow)
                }
                Spacer()
            }
            .padding(.leading, 20)
            .frame(height: 45)
        }
    }
    
    struct CharactersCarouselView: View {
        @Binding var characters: [CharacterModel]
        @Binding var selection: Int
        @Binding var scrollOffset: CGFloat
        @State private var tabHeight: CGFloat = .zero
        
        private var maxHeight: CGFloat {
            return screenSize.height * 0.33
        }
        
        var body: some View {
            TabView(selection: $selection) {
                ForEach(characters, id: \.id) { character in
                    HStack {
                        AsyncImage(urlString: character.imageUrl)
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
