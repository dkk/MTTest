//
//  MenuPresenterTests.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import XCTest
@testable import MyToysTest

class MenuPresenterTests: XCTestCase {
    var menuServiceMock: MenuService!
    var viewMock: MenuView!
    var menuDelegateMock: MenuDelegate!

    class MenuServiceMock: MenuService {
        var completion: ((_ navigationEntries: [NavigationElement]?) -> Void)?
        func retrieveMenuContent(completion: @escaping(_ navigationEntries: [NavigationElement]?) -> Void) {
            self.completion = completion
        }
    }

    class ViewMock: MenuView {
        var currentNavigationElements: [NavigationElement]?
        var currentLabel: String?
        var currentDelegate: MenuTableViewControllerDelegate?
        var dismissCalled = false

        var nextNavigationElements: [NavigationElement]?
        var nextLabel: String?

        weak var menuViewDelegate: MenuViewDelegate?

        func setCurrent(navigationElements: [NavigationElement]) {
            currentNavigationElements = navigationElements
        }

        func setCurrent(label: String) {
            currentLabel = label
        }

        func dismiss() {
            dismissCalled = true
        }
        
        func showNextWith(label: String, navigationElements: [NavigationElement]) {
            nextLabel = label
            nextNavigationElements = navigationElements
        }
    }

    class MenuDelegateMock: MenuDelegate {
        var url: URL?
        func linkTapped(url: URL) {
            self.url = url
        }
    }

    override func setUp() {
        super.setUp()

        menuServiceMock = MenuServiceMock()
        viewMock = ViewMock()
        menuDelegateMock = MenuDelegateMock()
    }
    
    override func tearDown() {
        viewMock = nil
        menuServiceMock = nil
        menuDelegateMock = nil

        super.tearDown()
    }
    
    func testMenuDelegateGetsTheNewUrl() {
        let menuPresenter = MenuPresenter(view: viewMock, service: menuServiceMock)
        menuPresenter.delegate = menuDelegateMock
        viewMock.menuViewDelegate?.didSelect(navigationElement: .link(label: "test", url: "http://www.test.com"))

        guard let menuDelegateMock = menuDelegateMock as? MenuDelegateMock else {
            XCTFail()
            return
        }
        XCTAssertEqual(menuDelegateMock.url?.absoluteString ?? "", "http://www.test.com")
    }

    func testNavigationElementsArePassedToTheView() {
        let menuPresenter = MenuPresenter(view: viewMock, service: menuServiceMock)
        XCTAssertNotNil(menuPresenter)
        guard let menuServiceMock = menuServiceMock as? MenuServiceMock, let viewMock = viewMock as? ViewMock else {
            XCTFail()
            return
        }

        let expectedNavigationElements = NavigationElement.link(label: "test", url: "http://www.test.com")
        menuServiceMock.completion?([expectedNavigationElements])
        XCTAssertEqual(viewMock.currentNavigationElements?.count, 1)
    }

    func testShowNextIsCalledWhenANodeIsSelected() {
        let menuPresenter = MenuPresenter(view: viewMock, service: menuServiceMock)
        XCTAssertNotNil(menuPresenter)
        guard let viewMock = viewMock as? ViewMock else {
            XCTFail()
            return
        }

        let expectedChildren = [NavigationElement.link(label: "test", url: "http://www.test.com")]
        let expectedLabel = "the node"
        let node = NavigationElement.node(label: expectedLabel, children: expectedChildren)
        viewMock.menuViewDelegate?.didSelect(navigationElement: node)

        if let nextNavigationElements = viewMock.nextNavigationElements, let nextLabel = viewMock.nextLabel {
            XCTAssertEqual(nextNavigationElements.count, expectedChildren.count)
            XCTAssertEqual(nextLabel, expectedLabel)
        } else {
            XCTFail()
        }
    }

    func testMenuViewIsDismissedWhenALinkIsSelected() {
        let menuPresenter = MenuPresenter(view: viewMock, service: menuServiceMock)
        menuPresenter.delegate = menuDelegateMock
        viewMock.menuViewDelegate?.didSelect(navigationElement: .link(label: "test", url: "http://www.test.com"))

        guard let viewMock = viewMock as? ViewMock else {
            XCTFail()
            return
        }

        XCTAssert(viewMock.dismissCalled)
    }

    func testMenuViewIsNotDismissedWhenANodeIsSelected() {
        let menuPresenter = MenuPresenter(view: viewMock, service: menuServiceMock)
        menuPresenter.delegate = menuDelegateMock
        let expectedChildren = [NavigationElement.link(label: "test", url: "http://www.test.com")]
        let expectedLabel = "the node"
        let node = NavigationElement.node(label: expectedLabel, children: expectedChildren)
        viewMock.menuViewDelegate?.didSelect(navigationElement: node)

        guard let viewMock = viewMock as? ViewMock else {
            XCTFail()
            return
        }

        XCTAssertFalse(viewMock.dismissCalled)
    }
    
}
