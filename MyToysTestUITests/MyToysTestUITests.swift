//
//  MyToysTestUITests.swift
//  MyToysTestUITests
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import XCTest

class MyToysTestUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        XCUIApplication().launch()
    }

    // This UI test will only work with network, and only as long as the menu elements don't change.
    // usually you would use a Mock-Scheme for this kind of tests
    func testStartPageAndMenu() {
        let app = XCUIApplication()

        //open the menu
        app.navigationBars["MyToys"].buttons["Menu"].tap()

        //navigate forward selecting nodes
        let tablesQuery = app.tables
        waitForElementToAppear(tablesQuery.staticTexts["Alter"])
        tablesQuery.staticTexts["Alter"].tap()
        tablesQuery.staticTexts["Baby & Kleinkind"].tap()

        //navigate back (test back button)
        app.navigationBars["Baby & Kleinkind"].buttons["Alter"].tap()
        app.navigationBars["Alter"].buttons["myToys"].tap()

        //close the menu
        app.navigationBars["myToys"].buttons["Close"].tap()

        // open the menu
        let mytoysNavigationBar = app.navigationBars["MyToys"]
        let menuButton = mytoysNavigationBar.buttons["Menu"]
        menuButton.tap()

        //select some links
        waitForElementToAppear(tablesQuery.staticTexts["Alle Angebote im Überblick"])
        tablesQuery.staticTexts["Alle Angebote im Überblick"].tap()
        menuButton.tap()
        waitForElementToAppear(tablesQuery.staticTexts["Kategorien"])
        tablesQuery.staticTexts["Kategorien"].tap()
        tablesQuery.staticTexts["Sport & Garten"].tap()
        tablesQuery.staticTexts["Alles von Sport & Garten"].tap()
        menuButton.tap()
        waitForElementToAppear(tablesQuery.staticTexts["Artikel aus der Werbung"])
        tablesQuery.staticTexts["Artikel aus der Werbung"].tap()

        //go back two times
        mytoysNavigationBar.buttons["<"].tap()
        mytoysNavigationBar.buttons["<"].tap()
    }
}
