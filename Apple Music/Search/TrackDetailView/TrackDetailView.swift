//
//  TrackDetailView.swift
//  Apple Music
//
//  Created by Саша Руцман on 18/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrackTapped(_ sender: Any) {
    }
    
    @IBAction func nextTrackTapped(_ sender: Any) {
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
    }
}
