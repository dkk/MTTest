//
//  NavigationEntriesModel.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import Foundation
import ObjectMapper

class NavigationEntriesModel: Mappable {
    private var navigationEntryModels: [NavigationEntryModel]?
    required init?(map: Map) { }

    func mapping(map: Map) {
        navigationEntryModels <- map["navigationEntries"]
    }

    var navigationEntries: [NavigationElement]? {
        return navigationEntryModels?.flatMap {$0.navigationEntry}
    }
}
