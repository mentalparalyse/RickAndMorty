//
//  Coordinator.swift
//  RickAndMorty
//
//  Created by Lex Sava on 30.11.2023.
//

import OSLog
import SwiftUI

@MainActor
protocol CoordinatorProtocol: AnyObject {
    var id: UUID { get set }
    var parent: CoordinatorProtocol? { get }
    var childs: [WeakCoordinator] { get set }
    func add(child: CoordinatorProtocol)
    func remove(child: CoordinatorProtocol)
    func handle(action: CoordinatorAction)
}

extension CoordinatorProtocol {
    func remove(child: CoordinatorProtocol) {
        childs.removeAll(where: { $0.coordinator?.id == child.id })
    }
    
    func add(child: CoordinatorProtocol) {
        guard !childs.contains(where: { $0.coordinator?.id == child.id }) else {
            Logger.coordinator.warning("Cannot add child reason: Child already exist.")
            return
        }
        childs.append(.init(coordinator: child))
    }
}

final class WeakCoordinator {
    private(set) weak var coordinator: CoordinatorProtocol?
    
    init(coordinator: CoordinatorProtocol) {
        self.coordinator = coordinator
    }
}
