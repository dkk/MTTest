//
//  NavigationEntryModel.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import Foundation
import ObjectMapper

class NavigationEntryModel: Mappable {
    enum NavigationType: String {
        case section = "section"
        case node = "node"
        case link = "link"
        case externalLink = "external-link"
    }

    private var type: NavigationType?
    private var label: String?
    private var children: [NavigationEntryModel]?
    private var url: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        type <- map["type"]
        label <- map["label"]
        children <- map["children"]
        url <- map["url"]
    }

    var navigationEntry: NavigationElement? {
        guard let type = type, let label = label else { return nil }

        switch type {
        case .node, .section:
            guard let children = children?.flatMap({$0.navigationEntry}) else { return nil }

            if type == .node {
                return NavigationElement.node(label: label, children: children)
            } else {
                return NavigationElement.section(label: label, children: children)
            }

        default: // .link, .externalLink
            guard let url = url else { return nil }

            return NavigationElement.link(label: label, url: url)
        }
    }
}
