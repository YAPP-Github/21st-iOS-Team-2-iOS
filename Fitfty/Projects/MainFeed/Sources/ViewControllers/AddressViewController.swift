//
//  AddressViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class AddressViewController: UIViewController {
    
    private var coordinator: AddressCoordinatorInterface
    private var viewModel: AddressViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: AddressCoordinatorInterface, viewModel: AddressViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .darkGray
        searchController.searchBar.placeholder = "지금 어디에 계세요?"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        return searchController
    }()
    
}

private extension AddressViewController {
    
    func setUp() {
        setUpNavigationBar()
        setUpLayout()
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "주소를 설정해주세요."
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
    }
}
