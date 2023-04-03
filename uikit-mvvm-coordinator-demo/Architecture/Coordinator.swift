//
//  Coordinator.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import Foundation
import RxSwift

class Coordinator<Result> {

    /// Utility `DisposeBag` used by the subclasses for RxSwift
    let bag = DisposeBag()

    /// Unique identifier.
    private let identifier = UUID()

    /// Dictionary of the child coordinators. Every child coordinator should be added to the dictionary and kept in
    /// the memory.
    /// Key is the child coordinator's `identifier`.
    /// Value is `AnyObject` type since Swift can't store generic types in an array.
    private var childCoordinators = [UUID: AnyObject]()

    /// Store the coordinator in the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Release the coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T>(coordinator: Coordinator<T>) {
        print("releasing coordinator: \(coordinator)")
        childCoordinators[coordinator.identifier] = nil
    }

    /// 1. Stores coordinator in the dictionary of child coordinators.
    /// 2. Calls the coordinator's `start()` method.
    /// 3. On the `onNext:` method of the returned observable from `start()`, the coordinator is removed from the
    ///    dictionary of child coordinators.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .take(1)
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }

    /// Starts the coordinator job.
    ///
    /// - Returns: Result of coordinator job.
    @discardableResult
    func start() -> Observable<Result> {
        fatalError("Start method should be implemented.")
    }

}

