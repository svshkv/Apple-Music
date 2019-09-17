//
//  MainTabBarController.swift
//  Apple Music
//
//  Created by Саша Руцман on 16/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        viewControllers = [
            generateVC(rootVC: SearchViewController(), image: #imageLiteral(resourceName: "search"), title: "Search"),
            generateVC(rootVC: ViewController(), image: #imageLiteral(resourceName: "library"), title: "Library")
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
    
}
