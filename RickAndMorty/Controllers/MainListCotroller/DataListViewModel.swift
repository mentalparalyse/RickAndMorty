//
//  ViewModel.swift
//  TestTask
//
//  Created by Lex Sava on 28.11.2023.
//

import Foundation
import Combine

@MainActor
class ContentViewModel<Coordinator: Routing>: ObservableObject {
    var coordinator: Coordinator?
    
    @Published var currentSelection: AccessLinks = .character
    
    @Published var displayableData: [DisplayedData] = []
    @Published var searchDataResults: [DisplayedData] = []
    
    @Published private(set) var responseInfo: ResultInfo?
    
    @Published var searchText: String = ""
    @Published var selection: Int = 0
    
    private let bag = CancelBag()
    let services: ServicesContainerProtocol
    
    init(_ services: ServicesContainerProtocol) {
        self.services = services
        setupObservers()
    }
}

extension ContentViewModel {
    func setupObservers() {
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
                case .location:
                    self.loadLocations()
                case .character:
                    self.loadCharacters()
                case .episode:
                    self.loadEpisodes()
                }
            }
            .store(in: bag)
    }
    
    func loadNext() {
        loadCharacters()
    }
    
    private func results(for search: String) -> [DisplayedData] {
        return searchDataResults.filter { $0.title.contains(search) }
    }
    
    private func loadData<T: ResponseModelProtocol>(
        model type: T.Type,
        url link: String,
        _ transform: @escaping (T) -> [DisplayedData]
    ) {
        Task.detached(priority: .background) { [weak self] in
            guard let self else { return }
            let result = await self.services.networkService.load(model: type, link: link)
            
            await MainActor.run {
                switch result {
                case let .success(success):
                    guard let resultModels = success.map(transform),
                            !self.displayableData.contains(where: { $0.id == resultModels.first?.id }) else { return }
                    self.displayableData.append(contentsOf: resultModels)
                    self.searchDataResults = self.displayableData
                    self.responseInfo = success?.info
                case let .failure(failure):
                    self.handle(error: failure)
                }
            }
        }
    }
    
    private func loadCharacters() {
        let pageLink = responseInfo?.next ?? currentSelection.initialLink
        loadData(model: CharacterResultsModel.self, url: pageLink) { model in
            model.results.compactMap { .init(character: $0) }
        }
    }
    
    private func loadLocations() {
        loadData(model: LocationResultsModel.self, url: AccessLinks.location.initialLink) { model in
            model.results.compactMap { .init(location: $0) }
        }
    }
    
    private func loadEpisodes() {
        loadData(model: EpisodeModelResult.self, url: AccessLinks.episode.initialLink) { model in
            model.results.compactMap { .init(episode: $0) }
        }
    }
    
    private func handle(error: NetworkError) {
        
    }
}
#if DEBUG
extension ContentViewModel {
    
    public func loadModels<T: ResponseModelProtocol>(
        _ type: T.Type, 
        _ link: AccessLinks,
        _ transform: @escaping (T) -> [DisplayedData]
    )  {
        loadData(model: type, url: link.initialLink, transform)
    }
    
    
}
#endif
