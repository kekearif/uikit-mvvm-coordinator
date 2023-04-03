//
//  HomeViewModel.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/4/1.
//

import RxCocoa
import RxRelay
import RxSwift

struct HomeViewModel {

    // MARK: - Events

    struct Event {
        let pushButtonTapped = PublishRelay<Void>()
        let presentButtonTapped = PublishRelay<Void>()
    }

    // MARK: - State

    struct State {
        let message: Driver<String?>
    }

    // MARK: - Properties

    let title = "Home"
    let message = BehaviorRelay<String?>(value: "Update message in SecondaryVC")
    let state: State
    let event = Event()

    // MARK: - Initializers

    init() {
        self.state = State(message: message.asDriver(onErrorJustReturn: nil))
    }

}
