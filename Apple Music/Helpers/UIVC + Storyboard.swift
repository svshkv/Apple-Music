//
//  UIVC + Storyboard.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() as? T {
            return vc
        } else {
            fatalError("Error: no initial vc in \(name) storyboard")
        }
    }
}
