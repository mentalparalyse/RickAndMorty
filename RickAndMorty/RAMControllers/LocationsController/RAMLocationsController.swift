
//  RAMLocationsController.swift
//  RickAndMorty
//
//  Created by Lex Sava on 11/30/18.
//  Copyright © 2018 Lex Sava. All rights reserved.


import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RAMLocationsController: UIViewController {
  public weak var presenter: RAMViewToPresenterProtocol?
  
  private(set) var locations: [LocationModel]?
  
  private lazy var locationsTable: UITableView! = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.backgroundColor = .white
    tableView.separatorStyle = .none
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.rowHeight = 45
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    return tableView
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(locationsTable)
    view.backgroundColor = .white
    presenter?.updateView()
    setupView()
  }
}


extension RAMLocationsController: RAMPresenterToViewProtocol{
  internal func showLocations(locations: LocationModel) {
    self.locations = []
    self.locations?.append(locations)
    locationsTable.reloadData()
  }
  
  internal func showError(error: Error) {
    print(error)
  }
}

extension RAMLocationsController: UITableViewDataSource{
  internal func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return locations?[section].results.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.backgroundColor = .lightGray
    print(locations?[indexPath.section].results[indexPath.row].name ?? "")
    cell.textLabel?.text = locations?[indexPath.section].results[indexPath.row].name ?? ""
    return cell
  }
}


extension RAMLocationsController{
  private func setupView(){
    locationsTable.snp.makeConstraints { maker in
      maker.center.equalToSuperview()
      maker.size.equalToSuperview()
    }
  }
}
