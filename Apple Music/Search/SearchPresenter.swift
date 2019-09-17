//
//  SearchPresenter.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright (c) 2019 Саша Руцман. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    
    case .some:
        print("presenter .some")
    case .presentTracks(let searchResults):
        print("presentTracks")
        let cells = searchResults?.results.map({ (track) in
            cellViewModel(from: track)
        }) ?? []
        let searchViewModel = SearchViewModel.init(cells: cells)
        viewController?.displayData(viewModel: Search.Model.ViewModel.ViewModelData.displayTracks(searchViewModel: searchViewModel))
    }
  }
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell(iconUrlString: track.artworkUrl100,
                                    trackName: track.trackName ?? "None",
                                    collectionName: track.trackName ?? "None",
                                    artistName: track.artistName)
    }
  
}
