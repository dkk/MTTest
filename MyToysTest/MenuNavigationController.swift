//
//  MenuNavigationController.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import UIKit

protocol MenuView: class {
    weak var menuViewDelegate: MenuViewDelegate? { get set }

    func setCurrent(navigationElements: [NavigationElement])
    func setCurrent(label: String)
    func dismiss()
    func showNextWith(label: String, navigationElements: [NavigationElement])
}

protocol MenuViewDelegate: class {
    func didSelect(navigationElement: NavigationElement)
}

class MenuNavigationController: UINavigationController, MenuView, MenuTableViewControllerDelegate {
    var presenter: MenuPresenter!
    weak var menuViewDelegate: MenuViewDelegate?
    private var lastMenuTableViewController: MenuTableViewController? {
        return viewControllers.last as? MenuTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        lastMenuTableViewController?.delegate = self
    }

    //MARK: - MenuView

    func setCurrent(navigationElements: [NavigationElement]) {
        lastMenuTableViewController?.navigationElements = navigationElements
    }

    func setCurrent(label: String) {
        lastMenuTableViewController?.label = label
    }

    func dismiss() {
        dismiss(animated: true)
    }

    func showNextWith(label: String, navigationElements: [NavigationElement]) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "menuTableViewController") as? MenuTableViewController {
            controller.navigationElements = navigationElements
            controller.label = label
            controller.delegate = self
            pushViewController(controller, animated: true)
        }
    }

    //MARK: - MenuTableViewControllerDelegate

    func didSelect(navigationElement: NavigationElement) {
        menuViewDelegate?.didSelect(navigationElement: navigationElement)
    }
}
