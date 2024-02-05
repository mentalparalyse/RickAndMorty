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
    
    @Published private(set) var responseInfo: ResultInfo?
        
    private let bag = CancelBag()
    var services: ServicesContainerProtocol? {
        coordinator?.servicesContainer
    }
    
    #if TEST
    init(_ coordinator: Coordinator) {
        self.coordinator = coordinator
        setupObservers()
    }
    #else
    init() {
        setupObservers()
    }
    #endif
}

extension ContentViewModel {
    func setupObservers() {
        $currentSelection
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: selectionChanged(to:))
            .store(in: bag)
    }
    
    func loadNext() {
        updateCurrentData(from: currentSelection)
    }
    
    private func selectionChanged(to link: AccessLinks) {
        //First get rid of old data inside of results array.
        displayableData.removeAll()
        responseInfo = nil
        updateCurrentData(from: link)
    }
    
    private func updateCurrentData(from selection: AccessLinks) {
        switch selection {
        case .location:
            self.loadLocations()
        case .character:
            self.loadCharacters()
        case .episode:
            self.loadEpisodes()
        }
    }
    
    private func loadData<T: ResponseModelProtocol>(
        model type: T.Type,
        url link: String,
        _ transform: @escaping (T) -> [DisplayedData]
    ) {
        Task { [weak self] in
            guard let self, let result = await self.services?.networkService.load(model: type, link: link) else {
                return
            }
            
            await MainActor.run {
                switch result {
                case let .success(success):
                    guard let resultModels = success.map(transform),
                            !self.displayableData.contains(where: { $0.id == resultModels.first?.id }) else { return }
                    self.displayableData.append(contentsOf: resultModels)
                    self.responseInfo = success?.info
                case let .failure(failure):
                    self.handle(error: failure)
                }
            }
        }
    }
    
    private func loadCharacters() {
        let pageLink = currentSelection.initialLink
//        let pageLink = responseInfo?.next ?? currentSelection.initialLink
        loadData(model: CharacterResultsModel.self, url: pageLink) { model in
            model.results.compactMap { .init(character: $0) }
        }
    }
    
    private func loadLocations() {
        let pageLink = currentSelection.initialLink
//        let pageLink = responseInfo?.next ?? currentSelection.initialLink
        loadData(model: LocationResultsModel.self, url: pageLink) { model in
            model.results.compactMap { .init(location: $0) }
        }
    }
    
    private func loadEpisodes() {
        let pageLink = currentSelection.initialLink
//        let pageLink = responseInfo?.next ?? currentSelection.initialLink
        loadData(model: EpisodeModelResult.self, url: pageLink) { model in
            model.results.compactMap { .init(episode: $0) }
        }
    }
    
    private func handle(error: NetworkError) {
        print(error.localizedDescription)
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
