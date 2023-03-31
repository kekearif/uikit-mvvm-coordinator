//
//  Navigator.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit

/// An object responsible for navigating to other view controllers from another view controller.
enum Navigator {

    case push(to: UINavigationController)
    case modal(from: UIViewController)
    case root(in: UIWindow)

    var viewController: UIViewController? {
        switch self {
        case let .push(navigationController):
            return navigationController
        case let .modal(presentingViewController):
            return presentingViewController
        case .root:
            return nil
        }
    }

    func navigate(to viewController: UIViewController) {
        switch self {
        case let .push(navigationController):
            navigationController.pushViewController(viewController, animated: true)
        case let .modal(presentingViewController):
            presentingViewController.present(viewController, animated: true)
        case let .root(window):
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }

}

