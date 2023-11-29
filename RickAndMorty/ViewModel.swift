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
    //    @Published var characters: [CharacterModel] = []
    //    @Published var locations: [LocationModel] = []
    //    @Published var searchCharacters: [CharacterModel] = []
    
    @Published private var responseInfo: ResultInfo?
    
    @Published var searchText: String = ""
    @Published var selection: Int = 0
    
    private let bag = CancelBag()
    private let networkService: NetworkServiceProtocol
    
    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
//        updateData(AccessLinks.character.createURL().absoluteString)
        setupObservers()
    }
}

extension ContentViewModel {
    func setupObservers() {
        $selection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                if $0 == self.displayableData.count,
                   let nextPage = self.responseInfo?.next,
                   searchText.isEmpty {
                    self.updateData(nextPage)
                }
            }
            .store(in: bag)
        
        $searchText
            .sink { [weak self] value in
                guard let self else { return }
                self.searchDataResults = self.results(for: value)
            }
            .store(in: bag)
        
        $currentSelection
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .locations:
                    self.loadLocations()
                case .characters:
                    self.loadCharacters()
                case .episode:
                    self.loadEpisodes()
                }
            }
            .store(in: bag)
    }
    
    private func results(for search: String) -> [DisplayedData] {
        return searchDataResults.filter { $0.title.contains(search) }
    }
    
    private func loadData<T: ResponseModelProtocol>(model type: T.Type, url link: AccessLinks, _ transform: @escaping (T) -> [DisplayedData]) {
        Task { [weak self] in
            guard let self else { return }
            let result = await self.networkService.loadData(model: type, link: link)
            switch result {
            case .success(let success):
                self.displayableData = success.map(transform) ?? []
                self.searchDataResults = self.displayableData
                self.responseInfo = success?.info
            case .failure(let failure):
                self.handle(error: failure)
            }
        }
    }
    
    private func loadCharacters() {
        loadData(model: CharacterResultsModel.self, url: .character) { model in
            model.results.compactMap { .init(character: $0) }
        }
    }
    
    private func loadLocations() {
        loadData(model: LocationResultsModel.self, url: .location) { model in
            model.results.compactMap { .init(location: $0) }
        }
    }
    
    private func loadEpisodes() {
        loadData(model: EpisodeModelResult.self, url: .episode) { model in
            model.results.compactMap { .init(episode: $0) }
        }
    }
    
    private func handle(error: NetworkError) {
        
    }
    
    private func updateData(_ pageLink: String) {
        Task.detached(priority: .high) { @MainActor [weak self] in
            guard let self else { return }
            //            let newCharacters = await self.networkService.loadNextData(
            //                model: CharacterResultsModel.self,
            //                link: pageLink
            //            )
            //            self.searchCharacters.append(contentsOf: newCharacters?.results ?? [])
            //            self.characters.append(contentsOf: newCharacters?.results ?? [])
            //            self.charactersInfo = newCharacters?.info
        }
    }
}
