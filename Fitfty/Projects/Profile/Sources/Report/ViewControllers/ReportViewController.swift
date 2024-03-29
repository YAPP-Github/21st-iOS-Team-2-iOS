//
//  ReportViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine

final public class ReportViewController: UIViewController {
    
    private let coordinator: ReportCoordinatorInterface
    private let viewModel: ReportViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let reportPresentType: ReportPresentType
    private var userToken: String?
    private var boardToken: String?
    
    private lazy var userReportButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.setTitle("계정 신고", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(didTapUserReportButton), for: .touchUpInside)
        return button
    }()
    
    private let myPostBottomSheetView = MyPostBottomSheetView()
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
    }
    
    public init(
        coordinator: ReportCoordinatorInterface,
        viewModel: ReportViewModel,
        reportPresentType: ReportPresentType,
        userToken: String?,
        boardToken: String?
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.reportPresentType = reportPresentType
        self.userToken = userToken
        self.boardToken = boardToken
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setConstraintsLayout()
        
    }
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                    
                case .completed(let completed):
                    guard completed else {
                        return
                    }
                    self?.coordinator.popToRoot()
                }
            }).store(in: &cancellables)
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(myPostBottomSheetView)
        NSLayoutConstraint.activate([
            myPostBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myPostBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myPostBottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])
        switch reportPresentType {
        case .userReport:
            myPostBottomSheetView.setUpUserProfile()
            myPostBottomSheetView.setActionFirstButton(self, action: #selector(didTapUserReportButton))
            myPostBottomSheetView.setActionSecondButton(self, action: #selector(didTapUserBlockButton))
            
        case .postUserReport:
            myPostBottomSheetView.setUpUserPost()
            myPostBottomSheetView.setActionFirstButton(self, action: #selector(didTapUserReportButton))
            myPostBottomSheetView.setActionSecondButton(self, action: #selector(didTapPostReportButton))
            myPostBottomSheetView.setActionThirdButton(self, action: #selector(didTapPostBlockButton))
            myPostBottomSheetView.setActionFourthButton(self, action: #selector(didTapUserBlockButton))
        }
    
    }
    
    private func showBlockAlert(_ reportType: ReportType) {
        let message = reportType == .userReport ? "계정" : "게시글"
        let alert = UIAlertController(title: "정말 이 \(message)을 차단할까요?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default))
        alert.addAction(UIAlertAction(title: "차단하기", style: .default, handler: { _ in
            switch reportType {
            case .userReport:
                self.viewModel.input.didTapBlockButton(.userReport)
            case .postReport:
                self.viewModel.input.didTapBlockButton(.postReport)
            }
        }))
        present(alert, animated: true)
    }
    
    @objc func didTapUserReportButton(_ sender: Any?) {
        coordinator.showDetailReport(.userReport, userToken: userToken, boardToken: boardToken)
    }
    
    @objc func didTapPostReportButton(_ sender: Any?) {
        coordinator.showDetailReport(.postReport, userToken: userToken, boardToken: boardToken)
    }
    
    @objc func didTapUserBlockButton(_ sender: Any?) {
        showBlockAlert(.userReport)
    }
    
    @objc func didTapPostBlockButton(_ sender: Any?) {
        showBlockAlert(.postReport)
    }
    
}
