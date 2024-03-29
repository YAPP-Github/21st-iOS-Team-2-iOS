//
//  Auth.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Combine
import MessageUI

import Core

final public class AuthViewController: UIViewController {
    private let coordinator: AuthCoordinatorInterface
    
    private let contentView = AuthView()
    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
    
    public init(viewModel: AuthViewModel, coordinator: AuthCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureButtonTarget()
    }
    
    private func configureButtonTarget() {
        contentView.setEnterWithoutLoginButtonTarget(target: self, action: #selector(didTapEnterWithoutLoginButton))
        contentView.setLoginProblemButtonTarget(target: self, action: #selector(didTapLoginProblemButton))
        contentView.setKakaoButtonTarget(target: self, action: #selector(didTapKakaoButton))
        contentView.setAppleButtonTarget(target: self, action: #selector(didTapAppleButton))
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .pushPermissionView:
                    self?.coordinator.pushPermissionView()
                    
                case .pushMainFeedView:
                    self?.coordinator.pushMainFeedFlow()
                    
                case .showErrorAlert(let error):
                    self?.showErrorAlert(error)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func didTapKakaoButton() {
        viewModel.didTapKakaoLogin()
    }
    
    @objc
    private func didTapAppleButton() {
        viewModel.didTapAppleLogin()
    }
    
    @objc
    private func didTapEnterWithoutLoginButton() {
        viewModel.didTapEnterWithoutLoginButton()
    }
    
    @objc
    private func didTapLoginProblemButton() {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = makeMailViewController()
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
}

extension AuthViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func makeMailViewController() -> MFMailComposeViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(["team.fitfty@gmail.com"])
        mailViewController.setSubject("로그인 문제 문의")
        mailViewController.setMessageBody("문제 내용(스크린샷 또는 녹화 화면 첨부 가능):\n사용한 기기 종류:\n문의 답변을 받을 연락처:",
                                          isHTML: false)
        
        return mailViewController
    }
    
    private func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    private func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "메일 전송 실패",
                                                message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}
