//
//  NavigationElementTests.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import MyToysTest

class NavigationElementTests: XCTestCase {
    
    func testConvertLink() {
        let expectedLabel = "7-12 Monate"
        let expectedUrl = "http://www.mytoys.de/7-12-months/"
        let linkNavigationEntryModel = NavigationEntryModel(JSON: ["type": "link", "label": expectedLabel, "url": expectedUrl])
        let linkNavigationEntry = linkNavigationEntryModel?.navigationEntry
        if let linkNavigationEntry = linkNavigationEntry {
            if case .link(let label, let url) = linkNavigationEntry {
                XCTAssertEqual(label, expectedLabel)
                XCTAssertEqual(url, expectedUrl)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }

    func testConvertExternalLink() {
        let expectedLabel = "7-12 Monate"
        let expectedUrl = "http://www.mytoys.de/7-12-months/"
        let linkNavigationEntryModel = NavigationEntryModel(JSON: ["type": "external-link", "label": expectedLabel, "url": expectedUrl])
        let linkNavigationEntry = linkNavigationEntryModel?.navigationEntry
        if let linkNavigationEntry = linkNavigationEntry {
            if case .link(let label, let url) = linkNavigationEntry {
                XCTAssertEqual(label, expectedLabel)
                XCTAssertEqual(url, expectedUrl)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }

    func testConvertNode() {
        let navigationEntryModel = NavigationEntryModel(JSONString: "{ \"type\": \"node\", \"label\": \"Alles für die Windeltorte\", \"children\": [{ \"type\": \"link\", \"label\": \"Die Eiskönigin Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/eiskoenigin-windeltorte\" }, { \"type\": \"link\", \"label\": \"Star Wars Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/star-wars-windeltorte\"}, { \"type\": \"link\", \"label\": \"Winnie Puuh Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/winnie-puuh-windeltorte\"}, { \"type\": \"link\", \"label\": \"Kunterbunte Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-kunterbunt\" }, { \"type\": \"link\", \"label\": \"Für Jungen\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-jungen\"}, { \"type\": \"link\", \"label\": \"Für Mädchen\",\"url\": \"http://www.mytoys.de/mkt/windeltorte-maedchen\"}]}")
        let navigationEntry = navigationEntryModel?.navigationEntry
        if let navigationEntry = navigationEntry {
            if case .node(let label, let children) = navigationEntry {
                XCTAssertEqual(label, "Alles für die Windeltorte")
                XCTAssertEqual(children.count, 6)

                let linkNavigationEntry = children[3]
                if case .link(let label, let url) = linkNavigationEntry {
                    XCTAssertEqual(label, "Kunterbunte Windeltorte")
                    XCTAssertEqual(url, "http://www.mytoys.de/mkt/windeltorte-kunterbunt")
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }

    func testConvertSection() {
        let navigationEntryModel = NavigationEntryModel(JSONString: "{\"type\": \"section\", \"label\": \"Beratung & Inspiration\", \"children\": [{ \"type\": \"node\", \"label\": \"Alles für die Windeltorte\", \"children\": [{ \"type\": \"link\", \"label\": \"Die Eiskönigin Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/eiskoenigin-windeltorte\" }, { \"type\": \"link\", \"label\": \"Star Wars Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/star-wars-windeltorte\"}, { \"type\": \"link\", \"label\": \"Winnie Puuh Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/winnie-puuh-windeltorte\"}, { \"type\": \"link\", \"label\": \"Kunterbunte Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-kunterbunt\" }, { \"type\": \"link\", \"label\": \"Für Jungen\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-jungen\"}, { \"type\": \"link\", \"label\": \"Für Mädchen\",\"url\": \"http://www.mytoys.de/mkt/windeltorte-maedchen\"}]}]}")
        let navigationEntry = navigationEntryModel?.navigationEntry
        if let navigationEntry = navigationEntry {
            if case .section(let label, let children) = navigationEntry {
                XCTAssertEqual(label, "Beratung & Inspiration")
                XCTAssertEqual(children.count, 1)

                let nodeNavigationEntry = children[0]
                if case .node(let label, let children) = nodeNavigationEntry {
                    XCTAssertEqual(label, "Alles für die Windeltorte")
                    XCTAssertEqual(children.count, 6)
                } else {
                    XCTFail()
                }
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }

    func testConvertArrayOfSections() {
        let navigationEntriesModel = NavigationEntriesModel(JSONString: "{\"navigationEntries\":[{\"type\": \"section\", \"label\": \"Beratung & Inspiration\", \"children\": [{ \"type\": \"node\", \"label\": \"Alles für die Windeltorte\", \"children\": [{ \"type\": \"link\", \"label\": \"Die Eiskönigin Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/eiskoenigin-windeltorte\" }, { \"type\": \"link\", \"label\": \"Star Wars Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/star-wars-windeltorte\"}, { \"type\": \"link\", \"label\": \"Winnie Puuh Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/winnie-puuh-windeltorte\"}, { \"type\": \"link\", \"label\": \"Kunterbunte Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-kunterbunt\" }, { \"type\": \"link\", \"label\": \"Für Jungen\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-jungen\"}, { \"type\": \"link\", \"label\": \"Für Mädchen\",\"url\": \"http://www.mytoys.de/mkt/windeltorte-maedchen\"}]}]}, {\"type\": \"section\", \"label\": \"Beratung & Inspiration\", \"children\": [{ \"type\": \"node\", \"label\": \"Alles für die Windeltorte\", \"children\": [{ \"type\": \"link\", \"label\": \"Die Eiskönigin Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/eiskoenigin-windeltorte\" }, { \"type\": \"link\", \"label\": \"Star Wars Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/star-wars-windeltorte\"}, { \"type\": \"link\", \"label\": \"Winnie Puuh Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/winnie-puuh-windeltorte\"}, { \"type\": \"link\", \"label\": \"Kunterbunte Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-kunterbunt\" }, { \"type\": \"link\", \"label\": \"Für Jungen\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-jungen\"}, { \"type\": \"link\", \"label\": \"Für Mädchen\",\"url\": \"http://www.mytoys.de/mkt/windeltorte-maedchen\"}]}]}, {\"type\": \"section\", \"label\": \"Beratung & Inspiration\", \"children\": [{ \"type\": \"node\", \"label\": \"Alles für die Windeltorte\", \"children\": [{ \"type\": \"link\", \"label\": \"Die Eiskönigin Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/eiskoenigin-windeltorte\" }, { \"type\": \"link\", \"label\": \"Star Wars Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/star-wars-windeltorte\"}, { \"type\": \"link\", \"label\": \"Winnie Puuh Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/winnie-puuh-windeltorte\"}, { \"type\": \"link\", \"label\": \"Kunterbunte Windeltorte\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-kunterbunt\" }, { \"type\": \"link\", \"label\": \"Für Jungen\", \"url\": \"http://www.mytoys.de/mkt/windeltorte-jungen\"}, { \"type\": \"link\", \"label\": \"Für Mädchen\",\"url\": \"http://www.mytoys.de/mkt/windeltorte-maedchen\"}]}]}]}")

        let navigationEntries = navigationEntriesModel?.navigationEntries
        if let navigationEntries = navigationEntries {
            XCTAssertEqual(navigationEntries.count, 3)
        } else {
            XCTFail()
        }
    }
}
