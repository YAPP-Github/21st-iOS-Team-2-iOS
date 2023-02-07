//
//  AlbumListViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine

final public class AlbumListViewController: UIViewController {
    
    private let coordinator: AlbumListCoordinatorInterface
    private let viewModel: AlbumListViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
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
    
    private var dataSource: UITableViewDiffableDataSource<AlbumListSectionKind, AlbumInfo>?
    private var albums: [AlbumInfo]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.ouput.viewDidLoad()
    }
    
    public init(coordinator: AlbumListCoordinatorInterface, viewModel: AlbumListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
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
    }
}

private extension AlbumListViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .sections(let sections):
                    self?.applySnapshot(sections)
                }
            }).store(in: &cancellables)
    }
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<AlbumListSectionKind, AlbumInfo>(
            tableView: tableView, cellProvider: { tableView, indexPath, albumInfo in
                let cell = tableView.dequeueReusableCell(withIdentifier: AlbumListCell.className, for: indexPath) as? AlbumListCell
                
                cell?.setUp(
                    image: albumInfo.thumbNailImage,
                    title: albumInfo.name,
                    photoCount: String(albumInfo.photoCount)
                )
                return cell
            })
    }
    
    func applySnapshot(_ sections: [AlbumListSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<AlbumListSectionKind, AlbumInfo>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
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
