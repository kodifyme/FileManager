//
//  NavigationControllerBuilder.swift
//  Registration
//
//  Created by KOДИ on 29.02.2024.
//

import UIKit

protocol NavigationControllerBuilderProtocol {
    func setRootViewController(_ viewController: UIViewController) -> Self
    func setViewControllers(_ viewControllers: [UIViewController]) -> Self
    func build() -> UINavigationController
}

class NavigationControllerBuilder: NavigationControllerBuilderProtocol {
    
    private var rootViewController: UIViewController?
    private var viewControllers: [UIViewController] = []
    
    func setRootViewController(_ viewController: UIViewController) -> Self {
        self.rootViewController = viewController
        return self
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) -> Self {
        self.viewControllers = viewControllers
        return self
    }
    
    func build() -> UINavigationController {
        let navigationController: UINavigationController
        if let rootViewController = rootViewController {
            navigationController = UINavigationController(rootViewController: rootViewController)
        } else {
            navigationController = UINavigationController()
            navigationController.setViewControllers(viewControllers, animated: false)
        }
        return navigationController
    }
}
