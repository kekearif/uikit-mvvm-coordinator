//
//  SecondaryVC.swift
//  uikit-mvvm-coordinator-demo
//
//  Created by Keke Arif on 2023/3/31.
//

import UIKit

final class SecondaryVC: UIViewController {

    // MARK: - Properties

    private let viewModel: SecondaryViewModel

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
    }

}
