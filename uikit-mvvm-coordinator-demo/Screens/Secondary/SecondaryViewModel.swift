//
//  SecondaryViewModel.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

struct SecondaryViewModel {

    // MARK: - Events

    struct Event {
        let updateButtonTapped = PublishRelay<String?>()
    }

    // MARK: - Properties

    let title = "Secondary"
    let event = Event()

    private let bag = DisposeBag()

}
