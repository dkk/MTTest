//
//  MenuTableViewController.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate: class {
    func didSelect(navigationElement: NavigationElement)
}

class MenuTableViewController: UITableViewController {
    weak var delegate: MenuTableViewControllerDelegate?
    var navigationElements: [NavigationElement]? {
        didSet {
            tableView.reloadData()
        }
    }
    var sections: [NavigationElement]? {
        return navigationElements?.filter {
            if case .section(_) = $0 {
                return true
            }

            return false
        }
    }
    var label: String = "myToys" {
        didSet {
            title = label
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = label
    }

    // MARK: - Table view data source & delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return max(1, sections?.count ?? 1)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = sections, sections.count > section, case .section(_, let children) = sections[section] {
            return children.count
        }
        return navigationElements?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)

        var currentElement: NavigationElement?
        if let sections = sections, sections.count > indexPath.section, case .section(_, let children) = sections[indexPath.section] {
            currentElement = children[indexPath.row]
        } else if let navigationElements = navigationElements {
            currentElement = navigationElements[indexPath.row]
        } else {
            return cell
        }

        switch currentElement! {
        case .node(let label, _):
            cell.textLabel?.text = label
            cell.accessoryType = .disclosureIndicator
        case .link(let label, _):
            cell.textLabel?.text = label
            cell.accessoryType = .none
        default: break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = sections, sections.count > section, case .section(let label, _) = sections[section] else { return nil}

        return label
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var currentElement: NavigationElement?
        if let sections = sections, sections.count > indexPath.section, case .section(_, let children) = sections[indexPath.section] {
            currentElement = children[indexPath.row]
        } else if let navigationElements = navigationElements {
            currentElement = navigationElements[indexPath.row]
        }

        if currentElement != nil {
            delegate?.didSelect(navigationElement: currentElement!)
        }
    }

    //MARK: NavigationBar actions

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
