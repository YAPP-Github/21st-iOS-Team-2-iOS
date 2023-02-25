//
//  SettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import MessageUI

import Common
import Core

public final class SettingViewController: UIViewController {
    private weak var coordinator: SettingCoordinatorInterface?
    private var viewModel: SettingViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<SettingViewSection, Setting>?
    
    private let isAdmin = DefaultUserManager.shared.getAdminState()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: SettingCoordinatorInterface, viewModel: SettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator?.finished()
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(SettingCell.self)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
}

private extension SettingViewController {
    func setUp() {
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpLayout()
        setUpDataSource()
        applySnapshot()
    }
    
    func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 28).font ?? UIFont.systemFont(ofSize: 28)]
        navigationItem.title = "설정"
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator?.finished()
    }
    
    func didTapAskHelp() {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = makeMailViewController()
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func setUpLayout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = SettingViewSection(index: sectionNumber)
            switch section {
            case .setting: return self?.settingsLayout()
            default: return nil
            }
        }
    }
    
    func settingsLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(72)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return section
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SettingViewSection, Setting>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(SettingCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                if collectionView.isLastItem(indexPath) {
                    cell.hiddenLine()
                }
                cell.setUp(item: item)
                return cell
            })
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingViewSection, Setting>()
        snapshot.appendSections([.setting])
        if isAdmin {
            snapshot.appendItems(Setting.adminSettings())
        } else {
            snapshot.appendItems(Setting.userSettings())
        }
        dataSource?.apply(snapshot)
    }
}

extension SettingViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        switch item {
        case .profile:
            coordinator?.showProfileSetting()
            
        case .myInfo:
            coordinator?.showMyInfoSetting()
            
        case .termsOfUse:
            coordinator?.showTermsOfUse()
            
        case .privacyRule:
            coordinator?.showPrivacyRule()
            
        case .userReport:
            coordinator?.showReportList(reportType: .userReport)
            
        case .postReport:
            coordinator?.showReportList(reportType: .postReport)

        case .askHelp:
            didTapAskHelp()
            
        default: break
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func makeMailViewController() -> MFMailComposeViewController {
        let mailViewController = MFMailComposeViewController()
        mailViewController.mailComposeDelegate = self
        mailViewController.setToRecipients(["team.fitfty@gmail.com"])
        mailViewController.setSubject("문의하기")
        mailViewController.setMessageBody("문제 내용(스크린샷 또는 녹화 화면 첨부 가능):\n사용한 기기 종류:\n문의 답변을 받을 연락처:", isHTML: false)
        
        return mailViewController
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
