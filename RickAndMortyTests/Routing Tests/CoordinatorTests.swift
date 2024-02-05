//
//  CoordinatorTests.swift
//  RickAndMortyTests
//
//  Created by Lex Sava on 20.12.2023.
//

import XCTest
@testable import RickAndMorty

@MainActor
final class CoordinatorTests: XCTestCase {
    
    var services: ServicesContainerProtocol {
        StubServicesContainer()
    }
    
    func test_coordinator_initial_state() {
        let navigationController = NavigationController()
        
        let sut = StubCoordinator(parent: nil, startRoute: .main, servicesContainer: services, navigationController: navigationController)
        XCTAssertNil(sut.parent)
        XCTAssertTrue(sut.childs.isEmpty)
    }
    
    func test_add_child_coordinator() {
        let navigationController = NavigationController()
        let sut = StubAppCoordinator(window: .init(), navigationController: navigationController)
        let coordinator = StubCoordinator(
            parent: sut,
            startRoute: .details,
            servicesContainer: services,
            navigationController: navigationController
        )
        sut.start(with: coordinator)
        XCTAssertEqual(sut.childs.count, 1)
        XCTAssert(sut.childs.first?.coordinator?.id == coordinator.id)
    }
    
    func test_multiple_add_childs_coordinator() {
        let navigationController = NavigationController()
        let sut = StubAppCoordinator(window: .init(), navigationController: navigationController)
        let coordinator = StubCoordinator(
            parent: sut, 
            startRoute: .main,
            servicesContainer: services,
            navigationController: navigationController
        )
        sut.start(with: coordinator)
        sut.add(child:
                    StubCoordinator(
                        parent: coordinator,
                        startRoute: .details,
                        servicesContainer: services,
                        navigationController: navigationController
                    )
        )
        XCTAssertEqual(sut.childs.count, 2)
        XCTAssert(sut.childs.first?.coordinator?.id == coordinator.id)
    }
    
    func test_child_coordinator_remove() {
        let navigationController = NavigationController()
        let sut = StubAppCoordinator(window: .init(), navigationController: navigationController)
        let coordinator = StubCoordinator(parent: sut, startRoute: .main, servicesContainer: services, navigationController: navigationController)
        sut.start(with: coordinator)
        sut.remove(child: coordinator)
        XCTAssertTrue(sut.childs.isEmpty)
    }
    
    func test_child_coordinator_does_not_retain_coordinators() {
        let navigationController = NavigationController()
        let sut = StubAppCoordinator(window: .init(), navigationController: navigationController)
        var coordinator: StubCoordinator? = .init(parent: sut, startRoute: .main, servicesContainer: services, navigationController: navigationController)
        sut.add(child: coordinator!)
        XCTAssertNotNil(sut.childs.first?.coordinator)
        coordinator = nil
        XCTAssertNil(sut.childs.first?.coordinator)
    }
    
}
