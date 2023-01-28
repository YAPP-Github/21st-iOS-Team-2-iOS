//
//  PersonalInfoViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class PersonalInfoViewController: UIViewController {
    
    private weak var coordinator: PersonalInfoCoordinatorInterface?
    private var viewModel: PersonalInfoViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: PersonalInfoCoordinatorInterface, viewModel: PersonalInfoViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PersonalInfoViewController {
    
    func setUp() {
        view.backgroundColor = .white
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 28).font ?? UIFont.systemFont(ofSize: 28)]
        navigationItem.title = "개인 정보 설정"
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator?.finished()
    }
}
