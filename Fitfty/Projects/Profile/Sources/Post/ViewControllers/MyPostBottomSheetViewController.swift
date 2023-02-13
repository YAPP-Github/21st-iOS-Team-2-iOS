//
//  MyPostBottomSheetViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/26.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine

final public class MyPostBottomSheetViewController: UIViewController {
    
    private var coordinator: PostCoordinatorInterface
    private var viewModel: PostBottomSheetViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let myPostBottomSheetView = MyPostBottomSheetView()
    private var boardToken: String
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white.withAlphaComponent(0.2), alpha: 1)
        loadingView.stopAnimating()
        return loadingView
    }()
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(
        coordinator: PostCoordinatorInterface,
        viewModel: PostBottomSheetViewModel,
        boardToken: String
    ) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        self.boardToken = boardToken
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        bind()
        setConstratintsLayout()
        setButtonAction()
    }
   
    @objc func didTapModifyButton(_ sender: Any?) {
        coordinator.showModifyMyFitfty()
    }
    
    @objc func didTapDeleteButton(_ sender: Any?) {
        let alert = UIAlertController(title: "게시글을 정말 삭제하시겠어요?", message: "게시글은 수정도 가능해요.\n삭제한 게시물은 복구가 불가능해요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "돌아가기", style: .default))
        alert.addAction(UIAlertAction(title: "삭제하기", style: .default, handler: { _ in
            self.viewModel.input.didTapDeleteButton(boardToken: self.boardToken)
        }))
        present(alert, animated: true)
    }

}

private extension MyPostBottomSheetViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                case .isLoading(let isLoading):
                    isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
                case .completed(let completed):
                    guard completed else {
                        return
                    }
                    self?.coordinator.popToRoot()
                }
            }).store(in: &cancellables)
    }
    
    func setConstratintsLayout() {
        view.addSubviews(myPostBottomSheetView, loadingIndicatorView)
        NSLayoutConstraint.activate([
            myPostBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myPostBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myPostBottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setButtonAction() {
        myPostBottomSheetView.setActionDeleteButton(self, action: #selector(didTapDeleteButton))
        myPostBottomSheetView.setActionModifyButton(self, action: #selector(didTapModifyButton))
    }
    
}
