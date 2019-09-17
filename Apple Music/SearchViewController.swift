//
//  SearchViewController.swift
//  Apple Music
//
//  Created by Саша Руцман on 16/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
    private var timer: Timer?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let track = tracks[indexPath.row]
        if let trackName = track.trackName {
            cell.textLabel?.text = "\(String(describing: trackName))\n\(track.artistName)"
        } else {
            cell.textLabel?.text = "None\n\(track.artistName))"
        }
        
        cell.textLabel?.numberOfLines = 2
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let url = "https://itunes.apple.com/search"
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let parameters = ["term": "\(searchText)", "limit": "10"]
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (dataResponse) in
                if let error = dataResponse.error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let data = dataResponse.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    self.tracks = objects.results
                    self.tableView.reloadData()
                    
                } catch let jsonError {
                    print("Error to decode json: \(jsonError)")
                }
                //let someString = String(data: data, encoding: .utf8)
                //print(someString)
            })

        })
        
        
    }
}
