//
//  HomeViewModel.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/4/1.
//

import RxSwift
import RxRelay

struct HomeViewModel {

    // MARK: - Events

    struct Event {
        let pushButtonTapped = PublishRelay<Void>()
        let presentButtonTapped = PublishRelay<Void>()
    }

    let title = "Home"
    let event = Event()

}
