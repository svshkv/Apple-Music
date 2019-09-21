//
//  TrackCell.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol TrackViewModelCell {
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
    var iconUrlString: String? { get }
}

class TrackCell: UITableViewCell {
    
    static let reuseId = "TrackCell"
    

    @IBOutlet weak var addTrackButton: UIButton!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        self.cell = viewModel
        
        let savedTracks = UserDefaults.standard.savedTracks()
        let hasFavourite = savedTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        
    }

    
    @IBAction func addTrackAction(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        guard let cell = cell else { return }
        addTrackButton.isHidden = true
        
        var listOfTracks = defaults.savedTracks()
        
        listOfTracks.append(cell)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks, requiringSecureCoding: false) {
            print("Успешно!")
            defaults.set(savedData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}
