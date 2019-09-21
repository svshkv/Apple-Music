//
//  LibraryViewController.swift
//  Apple Music
//
//  Created by Саша Руцман on 21/09/2019.
//  Copyright (c) 2019 Саша Руцман. All rights reserved.
//

import UIKit
import SDWebImage

class LibraryViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var savedTracks = [SearchViewModel.Cell]()
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.tableFooterView = UIView()
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedTracks = UserDefaults.standard.savedTracks()
        table.reloadData()
    }
  
  
}

extension LibraryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        let cellViewModell = savedTracks[indexPath.row]
        //cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModell = savedTracks[indexPath.row]
        //print(cellViewModell.artistName)
        let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as? TrackDetailView
        guard let trackDetailView = trackDetailsView else { return }
        print("here")
        trackDetailView.delegate = self
        trackDetailView.set(viewModel: cellViewModell)
        let keyWindow = UIApplication.shared.keyWindow
        let tabBarVC = keyWindow?.rootViewController as? MainTabBarController
        tabBarVC?.trackDetailsView?.delegate = self
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: cellViewModell)
    }
    
}

extension LibraryViewController: TrackMovingDelagate {
    
    private func getTrack(isForwardTrack: Bool) -> SearchViewModel.Cell? {
        guard let indexPath = table.indexPathForSelectedRow else { return nil }
        table.deselectRow(at: indexPath, animated: true)
        var nextIndexPath: IndexPath!
        if isForwardTrack {
            nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if nextIndexPath.row == savedTracks.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if nextIndexPath.row == -1 {
                nextIndexPath.row = savedTracks.count - 1
            }
        }
        table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        let cellViewModel =  savedTracks[nextIndexPath.row]
        return cellViewModel
    }
    
    func moveBackToPreviousTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: false)
    }
    
    func moveForwardToNextTrack() -> SearchViewModel.Cell? {
        return getTrack(isForwardTrack: true)
    }
    
}
