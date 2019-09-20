//
//  TrackDetailView.swift
//  Apple Music
//
//  Created by Саша Руцман on 18/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelagate: class {
    func moveBackToPreviousTrack() -> SearchViewModel.Cell?
    func moveForwardToNextTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    

    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let player: AVPlayer = {
        let avplayer = AVPlayer()
        avplayer.automaticallyWaitsToMinimizeStalling = false //снижает задержку при загрузке до минимума
        return avplayer
    }()
    
    weak var delegate: TrackMovingDelagate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.layer.cornerRadius = 5
        trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    // MARK: - Setup
    
    func set(viewModel: SearchViewModel.Cell) {
        playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        miniTrackTitleLabel.text = viewModel.trackName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observePlayerCurrentTime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        miniTrackImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: - Time setup
    
    private func monitorStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        } // отслеживает, когда песня загрузится и заиграет
    }
    
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toString()
            let durationTime = self?.player.currentItem?.duration
            let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toString()
            self?.durationLabel.text = "-\(currentDurationTimeText)"
            self?.updateCurrentTimeSlider()
        } // с каким интервалом срабатывает функция, в каком потоке, что делаем
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    // MARK: - Animations
    
    private func enlargeTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil) // сколько длится анимация, задержка, как резко производится анимация
    }
    
    private func reduceTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.trackImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        tabBarDelegate?.minimizeTrackDetailController()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        self.player.volume = self.volumeSlider.value
    }
    
    @IBAction func previousTrackTapped(_ sender: Any) {
        
        guard let cellViewModel = delegate?.moveBackToPreviousTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func nextTrackTapped(_ sender: Any) {
        guard let cellViewModel = delegate?.moveForwardToNextTrack() else { return }
        self.set(viewModel: cellViewModel)
    }
    
    @IBAction func playPauseTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            enlargeTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: UIControl.State.normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: UIControl.State.normal)
            reduceTrackImageView()
        }
    }
}

extension CMTime {
    
    func toString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        return timeString
    }
    
}
