//
//  ReportListViewController.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine

final public class ReportListViewController: UIViewController {
    
    private let menuView = ReportMenuView()
    private var coordinator: ReportListCoordinatorInterface
    private var viewModel: ReportListViewModel
    private var reportType: ReportType
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReportListCell.self, forCellReuseIdentifier: ReportListCell.className)
        tableView.delegate = self
        tableView.separatorInset = .init(top: .zero, left: .zero, bottom: .zero, right: .zero)
        return tableView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<ReportListSectionKind, ReportListCellModel>?
    
    public init(
        coordinator: ReportListCoordinatorInterface,
        viewModel: ReportListViewModel,
        reportType: ReportType
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.reportType = reportType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        viewModel.input.viewDidLoad()
    }
    
    private func setUp() {
        bind()
        setConstraintsLayout()
        setNavigationBar()
        setDataSource()
        menuView.setUp(reportType: reportType)
    }
    
    @objc func didTapBackButton(_ sender: Any?) {
        coordinator.dismiss()
    }
    
}

private extension ReportListViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                    
                case .sections(let sections):
                    self?.applySnapshot(sections)
                }
            }).store(in: &cancellables)
    }
    
    func setConstraintsLayout() {
        view.addSubviews(menuView, tableView)
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            menuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            menuView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            menuView.heightAnchor.constraint(equalToConstant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: menuView.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<ReportListSectionKind, ReportListCellModel>(
            tableView: tableView, cellProvider: { tableView, indexPath, item in
                switch item {
                case .report(let account, let detailReport, let count, let filepath):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReportListCell.className, for: indexPath) as? ReportListCell
                    cell?.setReportType(self.reportType)
                    cell?.selectionStyle = .none
                    cell?.setUp(account: account, detailReport: detailReport, count: count, filePath: filepath)
                    return cell
                }
            })
    }
    
    func applySnapshot(_ sections: [ReportListSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<ReportListSectionKind, ReportListCellModel>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

extension ReportListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch reportType {
        case .userReport:
            return 44
        case .postReport:
            return 120
        }
    }
    
}
