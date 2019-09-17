//
//  Network Service.swift
//  Apple Music
//
//  Created by Саша Руцман on 17/09/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": "\(searchText)",
                "limit": "10",
                "media": "music"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (dataResponse) in
            if let error = dataResponse.error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = dataResponse.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                completion(objects)
            } catch let jsonError {
                print("Error to decode json: \(jsonError)")
                completion(nil)
            }
            //let someString = String(data: data, encoding: .utf8)
            //print(someString)
        })
    }
    
}
