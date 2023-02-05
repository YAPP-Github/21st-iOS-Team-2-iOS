//
//  AlbumListViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class AlbumListViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }

    private let coordinator: AlbumListCoordinatorInterface
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "최근 항목", isChevronButtonHidden: false)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(AlbumListCell.self, forCellReuseIdentifier: AlbumListCell.className)
        tableView.delegate = self
        tableView.separatorInset = .init(top: .zero, left: 20, bottom: .zero, right: 20)
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<Section, UUID>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: AlbumListCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setcontstratinsLayout() {
        view.addSubviews(navigationBarView, tableView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 66),
            tableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    private func setUp() {
        setcontstratinsLayout()
        setDataSource()
        applySnapshot()
    }
}

private extension AlbumListViewController {
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, UUID>(
            tableView: tableView, cellProvider: { tableView, indexPath, _ in
                let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListCell.className, for: indexPath) as? AlbumListCell
                cell?.setUp(image: CommonAsset.Images.sample.image, title: "내 앨범", photoCount: "1236")
                return cell
            })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<10).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
}

extension AlbumListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.dismiss()
    }
}
