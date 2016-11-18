//
//  Request.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

protocol MenuService {
    func retrieveMenuContent(completion: @escaping(_ navigationEntries: [NavigationElement]?) -> Void)
}

class MenuNetworkService: MenuService {
    let apiKey = "hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD"
    let urlPath = "https://mytoysiostestcase1.herokuapp.com/api/navigation"
    
    internal func retrieveMenuContent(completion: @escaping ([NavigationElement]?) -> Void) {
        guard let url = URL(string: urlPath) else {
            completion(nil)
            return
        }

        Alamofire.request(url, method: .get, headers: ["x-api-key": apiKey]).responseObject { (response: DataResponse<NavigationEntriesModel>) in

            if let model = response.result.value, let navigationElements = model.navigationEntries {
                completion(navigationElements)
            } else {
                completion(nil)
            }
        }
    }
}
