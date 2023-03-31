//
//  SecondaryCoordinator.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit
import RxSwift

final class SecondaryCoordinator: Coordinator<Void> {

    // MARK: - Properties

    private let navigator: Navigator

    // MARK: - Initializers

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    override func start() -> Observable<Void> {
        let viewModel = SecondaryViewModel()
        let vc = SecondaryVC(viewModel: viewModel)

        let nc: UINavigationController

        switch navigator {
        case .modal, .root:
            nc = CustomNC(rootViewController: vc)
            navigator.navigate(to: nc)
        case .push(let navigationController):
            nc = navigationController
            navigator.navigate(to: vc)
        }

        return vc.rx.deallocated
    }

}
