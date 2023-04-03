//
//  HomeCoordinator.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/4/1.
//

import UIKit
import RxSwift

final class HomeCoordinator: Coordinator<Void> {

    // MARK: - Properties

    private let navigator: Navigator

    // MARK: - Initializers

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    override func start() -> Observable<Void> {
        let viewModel = HomeViewModel()
        let vc = HomeVC(viewModel: viewModel)

        let nc: UINavigationController

        switch navigator {
        case .modal, .root:
            nc = CustomNC(rootViewController: vc)
            navigator.navigate(to: nc)
        case .push(let navigationController):
            nc = navigationController
            navigator.navigate(to: vc)
        }

        let pushResult = viewModel.event.pushButtonTapped
            .flatMapLatest { [weak self, weak nc] _ -> Observable<SecondaryCoordinator.Result> in
                guard let self = self, let nc = nc else { return .empty() }

                return self.pushSecondaryVC(from: nc)
            }

        let presentResult = viewModel.event.presentButtonTapped
            .flatMapLatest { [weak self, weak vc] _ -> Observable<SecondaryCoordinator.Result> in
                guard let self = self, let vc = vc else { return .empty() }

                return self.presentSecondaryVC(from: vc)
            }

        Observable.merge(pushResult, presentResult)
            .flatMapLatest { result -> Observable<String?> in
                switch result {
                case .textUpdated(let text):
                    return .just(text)
                case .cancel:
                    return .empty()
                }
            }
            .bind(to: viewModel.message)
            .disposed(by: bag)

        return vc.rx.deallocated
    }

    // MARK: - Navigation

    private func pushSecondaryVC(
        from navigationController: UINavigationController
    ) -> Observable<SecondaryCoordinator.Result> {
        let coordinator = SecondaryCoordinator(navigator: .push(to: navigationController))

        return coordinate(to: coordinator)
    }

    private func presentSecondaryVC(
        from viewController: UIViewController
    ) -> Observable<SecondaryCoordinator.Result> {
        let coordinator = SecondaryCoordinator(navigator: .modal(from: viewController))

        return coordinate(to: coordinator)
    }

}
