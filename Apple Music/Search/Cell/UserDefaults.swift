//
//  UserDefaults.swift
//  Apple Music
//
//  Created by Саша Руцман on 21/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else { return [] }
        return decodedTracks
    }
    
}
