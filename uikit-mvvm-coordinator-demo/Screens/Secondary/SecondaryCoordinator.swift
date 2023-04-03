//
//  SecondaryCoordinator.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit
import RxSwift

final class SecondaryCoordinator: Coordinator<SecondaryCoordinator.Result> {

    enum Result {
        case textUpdated(String?)
        case cancel
    }

    // MARK: - Properties

    private let navigator: Navigator

    // MARK: - Initializers

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    override func start() -> Observable<Result> {
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

        let result = viewModel.event.updateButtonTapped
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak vc, weak nc, weak self] _ in
                guard let vc = vc, let nc = nc, let self = self else { return }
                switch self.navigator {
                case .modal, .root:
                    vc.dismiss(animated: true)
                case .push:
                    nc.popViewController(animated: true)
                }
            })
            .map { Result.textUpdated($0) }

        return Observable
            .merge(
                result,
                vc.rx.deallocated.map { _ in .cancel }
            )
            .take(1)
    }

}
