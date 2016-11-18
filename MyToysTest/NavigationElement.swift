//
//  NavigationElement.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import Foundation

indirect enum NavigationElement {
    case section(label: String, children: [NavigationElement])
    case node(label: String, children: [NavigationElement])
    case link(label: String, url: String)
}

