//
//  HomeVC.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

final class HomeVC: ViewController {

    // MARK: - Properties

    private let viewModel: HomeViewModel
    private let bag = DisposeBag()

    // MARK: - Initializers

    init(viewModel: HomeViewModel) {
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

        let label = UILabel()
        label.textAlignment = .center

        let pushButton = UIButton()
        pushButton.setTitle("Push Secondary", for: .normal)
        pushButton.setTitleColor(.blue, for: .normal)

        let presentButton = UIButton()
        presentButton.setTitle("Present Secondary", for: .normal)
        presentButton.setTitleColor(.blue, for: .normal)

        let stackView = UIStackView(arrangedSubviews: [label, pushButton, presentButton])
        stackView.axis = .vertical

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
        }

        viewModel.state.message
            .drive(label.rx.text)
            .disposed(by: bag)

        pushButton.rx.tap
            .bind(to: viewModel.event.pushButtonTapped)
            .disposed(by: bag)

        presentButton.rx.tap
            .bind(to: viewModel.event.presentButtonTapped)
            .disposed(by: bag)
    }

}
