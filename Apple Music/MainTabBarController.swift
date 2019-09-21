//
//  MainTabBarController.swift
//  Apple Music
//
//  Created by Саша Руцман on 16/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit

protocol MainTabBarControllerDelegate: class {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let libraryVC: LibraryViewController = LibraryViewController.loadFromStoryboard()
    let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as? TrackDetailView
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrackDetailView()
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        libraryVC.tabBarDelegate = self
        searchVC.tabBarDelegate = self
        viewControllers = [
            generateVC(rootVC: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search"),
            generateVC(rootVC: libraryVC, image: #imageLiteral(resourceName: "library"), title: "Library")
        ]
        
    }
    
    private func generateVC(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        navigationVC.navigationBar.barTintColor = .white
        return navigationVC
    }
    
    
    private func setupTrackDetailView() {
        //let trackDetailsView = Bundle.main.loadNibNamed("TrackDetailView", owner: self, options: nil)?.first as? TrackDetailView
        guard let trackDetailView = trackDetailsView else { return }
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded() // ежесекундное изменение
                        self.tabBar.alpha = 0
                        self.trackDetailsView?.miniTrackView.alpha = 0
                        self.trackDetailsView?.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        trackDetailsView!.set(viewModel: viewModel)
    }
    
    func minimizeTrackDetailController() {
        
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded() // ежесекундное изменение
                        self.tabBar.alpha = 1
                        self.trackDetailsView?.miniTrackView.alpha = 1
                        self.trackDetailsView?.maximizedStackView.alpha = 0
        },
                       completion: nil)
    }
    
    
}
