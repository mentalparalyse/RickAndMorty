//
//  ViewModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation
import Combine

enum ListSelection: String, CaseIterable {
    case characters, locations, episode
 
}

class ContentViewModel: ObservableObject {
    @Published var currentSelection: ListSelection = .characters
    
    @Published var displayableData: [DisplayedData] = []
    @Published var searchDataResults: [DisplayedData] = []
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
            .receive(on: DispatchQueue.main)
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
        
        $currentSelection
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .locations:
                    self.load(model: LocationResultsModel.self, url: .location)
                case .characters:
                    self.load(model: CharacterResultsModel.self, url: .character)
                case .episode:
                    self.load(model: EpisodeModelResult.self, url: .episode)
                }
            }
            .store(in: bag)
    }
    
    private func results(for search: String) -> [DisplayedData] {
        searchDataResults = displayableData
        return searchDataResults.filter { $0.title.contains(search) }
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
    
    func load<T: ResponseModelProtocol>(model type: T.Type, url link: AccessLinks) {
        Task.detached(priority: .high) { [weak self] in
            guard let self else { return }
            await self.networkService.load(model: type, url: link)
                .sink { v in
                    switch v {
                    case .success(let response):
                        print(response)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                .store(in: bag)
        }
    }
}
