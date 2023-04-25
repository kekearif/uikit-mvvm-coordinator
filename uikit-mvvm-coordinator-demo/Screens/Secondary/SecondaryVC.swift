//
//  SecondaryVC.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit
import RxSwift

final class SecondaryVC: ViewController {

    // MARK: - Properties

    private let viewModel: SecondaryViewModel
    private let bag = DisposeBag()

    // MARK: - Initializers

    init(viewModel: SecondaryViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    init() {
        fatalError("init() has not been implemented")
    }

    @available(*, unavailable)
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) has not been implemented")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    // MARK: - Setup

    private func setupViews() {
        view.backgroundColor = .white
        title = viewModel.title

        let textField = UITextField()
        textField.placeholder = "Enter message text"

        let button = UIButton()
        button.setTitle("Update Message", for: .normal)
        button.setTitleColor(.blue, for: .normal)

        let stackView = UIStackView(arrangedSubviews: [textField, button])
        stackView.axis = .vertical
        stackView.alignment = .center

        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }

        button.rx.tap
            .withLatestFrom(textField.rx.text)
            .bind(to: viewModel.event.updateButtonTapped)
            .disposed(by: bag)
    }

}
