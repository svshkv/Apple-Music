//
//  SearchViewController.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright (c) 2019 Саша Руцман. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

    let searchController = UISearchController(searchResultsController: nil)
    var interactor: SearchBusinessLogic?
    var router: (NSObjectProtocol & SearchRoutingLogic)?
    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?

    @IBOutlet weak var table: UITableView!
    // MARK: Object lifecycle

  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    
    setupTableView()
    setupSearchBar()
  }
    
    private func setupTableView() {
            table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false // позволяет не затемняться бару при поиске
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // фиксиурет серчбар
        searchController.searchBar.delegate = self
    }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    
    case .some:
        print("vc .some")
    case .displayTracks(let searchViewModel):
        
        self.searchViewModel = searchViewModel
        print(self.searchViewModel)
        table.reloadData()
    }
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let cellViewModell = searchViewModel.cells[indexPath.row]
        cell.textLabel?.text = "\(cellViewModell.trackName)\n\(cellViewModell.artistName)"
        cell.textLabel?.numberOfLines = 2
        //cell.imageView?.image =
        return cell
    }

}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            print(searchText)
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
    }
    
}
