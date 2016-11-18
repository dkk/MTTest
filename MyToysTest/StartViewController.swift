//
//  StartViewController.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, MenuDelegate {
    @IBOutlet weak var webView: UIWebView!

    var webNavigationStack = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: "https://www.mytoys.de") {
            webNavigationStack = [url]
            loadLastUrl()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openMenu" {
            if let destination = segue.destination as? MenuNavigationController {
                let menuPresenter = MenuPresenter(view: destination, service: MenuNetworkService())
                menuPresenter.delegate = self
                destination.presenter = menuPresenter
            }
        }
    }

    private func loadLastUrl() {
        guard let lastUrl = webNavigationStack.last else { return }

        webView.loadRequest(URLRequest(url: lastUrl))
    }

    //MARK: - NavigationBar actions

    @IBAction func close(_ sender: Any) {
        guard webNavigationStack.count > 1 else { return }

        webNavigationStack.removeLast()
        if webNavigationStack.count <= 1 {
            navigationItem.leftBarButtonItems?.remove(at: 0)
        }
        loadLastUrl()
    }

    //MARK: - MenuDelegate

    func linkTapped(url: URL) {
        if let leftBarItem = navigationItem.leftBarButtonItem, navigationItem.leftBarButtonItems!.count < 2 {
            let backButton = UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(close))
            navigationItem.leftBarButtonItems = [backButton, leftBarItem]
        }
        webNavigationStack.append(url)
        webView.loadRequest(URLRequest(url: url))
    }
}

