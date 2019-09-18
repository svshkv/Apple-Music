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
    private var footerView = FooterView()
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
        //table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
        table.tableFooterView = footerView
    }
    
    private func setupSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false // позволяет не затемняться бару при поиске
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // фиксиурет серчбар
        searchController.searchBar.delegate = self
    }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
        
        self.searchViewModel = searchViewModel
        table.reloadData()
        footerView.hideLoader()
        
    case .displayFooterView:
        footerView.showLoader()
    }
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trackCell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell
        guard let cell = trackCell else { return UITableViewCell() }
        let cellViewModell = searchViewModel.cells[indexPath.row]
        //cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Введите поисковый запрос..."
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchViewModel.cells.count > 0 ? 0 : 250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModell = searchViewModel.cells[indexPath.row]
        //print(cellViewModell.artistName)
        let window = UIApplication.shared.keyWindow
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as? TrackDetailView
        guard let trackDetailView = trackDetailsView else { return }
        trackDetailView.set(viewModel: cellViewModell)
        window?.addSubview(trackDetailView)
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
