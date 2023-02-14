//
//  DetailReportViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine

final public class DetailReportViewController: UIViewController {
    
    let coordinator: DetailReportCoordinatorInterface
    let viewModel: DetailReportViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "신고 사유", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    private lazy var reportButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "신고하기")
        button.setButtonTarget(target: self, action: #selector(didTapReportButton(_:)))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ReportCell.self, forCellReuseIdentifier: ReportCell.className)
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.separatorInset = .init(top: .zero, left: 20, bottom: .zero, right: 20)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white.withAlphaComponent(0.2), alpha: 1)
        loadingView.stopAnimating()
        return loadingView
    }()
    
    private var dataSource: UITableViewDiffableDataSource<DetailReportSectionKind, ReportCellModel>?
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    public init(
        coordinator: DetailReportCoordinatorInterface,
        viewModel: DetailReportViewModel
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(navigationBarView, tableView, reportButton, loadingIndicatorView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 10),
            tableView.heightAnchor.constraint(equalToConstant: 240),
            
            reportButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 25),
            reportButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            reportButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setUp() {
        setConstraintsLayout()
        setDataSource()
    }
    
    @objc func didTapReportButton(_ sender: UITapGestureRecognizer) {
        viewModel.input.didTapReportButton()
    }
    
    @objc func didTapCancelButton(_ sender: UITapGestureRecognizer) {
        coordinator.dismiss()
    }
    
}

private extension DetailReportViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                    
                case .isLoading(let isLoading):
                    isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
                    
                case .completed(let isCompleted):
                    guard isCompleted else {
                        return
                    }
                    self?.coordinator.dismiss()
                    
                case .sections(let sections):
                    self?.applySnapshot(sections)
                }
            }).store(in: &cancellables)
    }
    
    func setDataSource() {
        dataSource = UITableViewDiffableDataSource<DetailReportSectionKind, ReportCellModel>(
            tableView: tableView, cellProvider: { tableView, indexPath, item in
                switch item {
                case .report(let title, let isSelected):
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReportCell.className, for: indexPath) as? ReportCell
                    cell?.selectionStyle = .none
                    cell?.setUp(title: title, isSelected: isSelected)
                    return cell
                }
            })
    }
    
    func applySnapshot(_ sections: [DetailReportSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<DetailReportSectionKind, ReportCellModel>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension DetailReportViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapTitle(index: indexPath.row)
    }
  
}
