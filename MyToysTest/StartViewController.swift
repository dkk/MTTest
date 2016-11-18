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
    @IBOutlet weak var closeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInitialPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openMenu" {
            if let destination = segue.destination as? MenuTableViewController {
                destination.delegate = self
            }
        }
    }

    func loadInitialPage() {
        if let url = URL(string: "https://www.mytoys.de") {
            webView.loadRequest(URLRequest(url: url))
        }
    }

    //MARK: - NavigationBar actions

    @IBAction func close(_ sender: Any) {
        navigationItem .setRightBarButton(nil, animated: true)
        loadInitialPage()
    }

    //MARK: - MenuDelegate

    func linkTapped(url: URL) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
        webView.loadRequest(URLRequest(url: url))
    }
}

