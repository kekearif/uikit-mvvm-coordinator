# UIKit MVVM Coordinator pattern
A UIKit MVVM Coordinator pattern demo using RxSwift

## Navigator

The *Navigator object* is provided to a coordinator, and it defines how to navigate to the next view controller, either by modal or push, and it holds the associated controller.

```swift
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
```

### Coordinator
The *Coordinator* class is defined as follows:
```swift
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
```

Here are some key points to note:
- All subsequent coordinators are stored in an array
- When the coordinator is deallocated, it will return an `Observable<Result>` and be removed from the array
- All coordinators should subclass this *Coordinator* class and override the *start* method

## Example

Here is a simple coordinator:
```swift
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

        viewModel.event.pushButtonTapped
            // Do UI updates on main thread
            .observe(on: MainScheduler.instance)
            .flatMapLatest { [weak self, weak nc] _ -> Observable<Void> in
                guard let self = self, let nc = nc else { return .empty() }

                return self.pushSecondaryVC(from: nc)
            }
            .subscribe()
            .disposed(by: bag)


        return vc.rx.deallocated
    }

    // MARK: - Navigation

    private func pushSecondaryVC(
        from navigationController: UINavigationController
    ) -> Observable<Void> {
        let coordinator = SecondaryCoordinator(navigator: .push(to: navigationController))

        return coordinate(to: coordinator)
    }

}
```
- The view controller and view model are first created in the coordinator's *start* method
- The navigator type is checked and the navigation controller set (it uses the existing navigation controller for a push and creates a new one for the modal)
- The relevant navigation logic is added. In this example, when the button is pressed, the secondary view controller will be navigated to via a push using the `coordinate(to: coordinator)` method.

For a more **advanced** example please refer to the code in the repo.

## Root Coordinator

To create the root coordinator use the `.root` option in the navigator and create a reference to the coordinator in the file:

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var coordinator: HomeCoordinator?
    private let bag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let coordinator = HomeCoordinator(navigator: .root(in: window))
        // Keep a reference
        self.coordinator = coordinator
        
        coordinator.start()
            .subscribe(onNext: {
                fatalError("Root view controller should never deinit")
            })
            .disposed(by: bag)
    }
    
}
```
