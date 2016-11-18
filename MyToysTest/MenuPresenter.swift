//
//  MenuPresenter.swift
//  MyToysTest
//
//  Created by Daniel Klöck on 18/11/16.
//  Copyright © 2016 Daniel Klöck. All rights reserved.
//

import Foundation

protocol MenuViewPresenter {
    init(view: MenuView, service: MenuService)
    weak var delegate: MenuDelegate? { get set }
}

protocol MenuDelegate: class {
    func linkTapped(url: URL)
}

class MenuPresenter: MenuViewPresenter, MenuViewDelegate {
    unowned var view: MenuView
    let service: MenuService
    weak var delegate: MenuDelegate?

    required init(view: MenuView, service: MenuService) {
        self.view = view
        self.service = service
        view.menuViewDelegate = self

        service.retrieveMenuContent { [weak self] navigationElements in
            guard let navigationElements = navigationElements, navigationElements.count > 0 else { return }

            self?.view.setCurrent(navigationElements: navigationElements)
        }
    }

    //MARK: - MenuViewDelegate
    func didSelect(navigationElement: NavigationElement) {
        switch navigationElement {
        case .link(_, let urlString):
            if let url = URL(string: urlString) {
                delegate?.linkTapped(url: url)
                view.dismiss()
            }

        case .node(let label, let children):
            view.showNextWith(label: label, navigationElements: children)

        default: break
        }
    }
}
