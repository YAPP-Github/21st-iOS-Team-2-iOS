//
//  WithdrawViewController.swift
//  Setting
//
//  Created by Watcha-Ethan on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

public enum WithdrawViewState {
    case withdraw
    case withdrawConfirm
}

final public class WithdrawViewController: UIViewController {
    private let coordinator: PersonalInfoCoordinatorInterface

    private let viewModel: WithdrawViewModel
    private let state: WithdrawViewState
    private var cancellables = Set<AnyCancellable>()

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let textLabel = UILabel()
    private let withdrawButton = FitftyButton(style: .enabled, title: "탈퇴할게요")
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    public init(state: WithdrawViewState,
                coordinator: PersonalInfoCoordinatorInterface,
                viewModel: WithdrawViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.state = state
        super.init(nibName: nil, bundle: nil)
        configure()
        bind()
        
        autoScroll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureState()
        configureTitleLabel()
        configureSubtitleLabel()
        configureTextLabel()
        configureWithdrawButton()
        configureCollectionView()
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .pushWithdrawConfirmView:
                    self?.coordinator.pushWithdrawConfirmView()
                    
                case .showErrorAlert(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureState() {
        switch state {
        case .withdraw:
            titleLabel.text = "계정을 삭제하시겠어요?"
            subTitleLabel.text = "탈퇴시 삭제되는 정보를 확인하세요.\n한번 삭제된 정보는 복구가 불가능해요."
            textLabel.text = "• 내 계정 정보\n• 업로드한 내 핏프티\n• 내가 즐겨찾기한 타인의 핏프티"
            withdrawButton.setTitle("탈퇴할게요", for: .normal)
            configureNavigationBar()
            
        case .withdrawConfirm:
            titleLabel.text = "탈퇴 신청이 완료됐어요."
            subTitleLabel.text = "오늘 날씨에 맞는 코디 추천이 필요하다면\n핏프티를 다시 찾아와주세요."
            textLabel.text = "•\n•\n•"
            textLabel.isHidden = true
            withdrawButton.setTitle("닫기", for: .normal)
            navigationItem.hidesBackButton = true
        }
    }
    
    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureTitleLabel() {
        view.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        titleLabel.font = FitftyFont.appleSDBold(size: 28).font
        titleLabel.textColor = CommonAsset.Colors.gray08.color
    }
    
    private func configureSubtitleLabel() {
        view.addSubviews(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textColor = CommonAsset.Colors.gray05.color
        subTitleLabel.font = FitftyFont.appleSDSemiBold(size: 14).font
    }
    
    private func configureTextLabel() {
        view.addSubviews(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        textLabel.numberOfLines = 0
        textLabel.textColor = CommonAsset.Colors.gray07.color
        textLabel.font = FitftyFont.appleSDBold(size: 14).font
    }
    
    private func configureWithdrawButton() {
        view.addSubviews(withdrawButton)
        NSLayoutConstraint.activate([
            withdrawButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            withdrawButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            withdrawButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        withdrawButton.setButtonTarget(target: self, action: #selector(didTapWithdrawButton))
    }
    
    private func configureCollectionView() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: withdrawButton.topAnchor)
        ])
        
        collectionView.register(WithdrawImageCell.self)
        collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
    }
    
    private func autoScroll() {
        let contentOffsetX = collectionView.contentOffset.x
        let afterContentOffsetX = contentOffsetX + 1.5
        
        if afterContentOffsetX > 350 {
            return
        }
        
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseInOut, animations: { [weak self] () -> Void in
            self?.collectionView.contentOffset = CGPoint(x: afterContentOffsetX, y: 0)
        }, completion: { [weak self] _ in
            self?.autoScroll()
        })
    }
    
    @objc
    private func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.pop()
    }
    
    @objc
    private func didTapWithdrawButton() {
        switch state {
        case .withdraw:
            viewModel.didTapWithdrawButton()
        case .withdrawConfirm:
            coordinator.showAuthView()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (_, _) -> NSCollectionLayoutSection? in
            return self?.withdrawSectionLayout()
        }
    }
    
    private func withdrawSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(221),
            heightDimension: .absolute(252)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 40, leading: 20, bottom: .zero, trailing: 20)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}

extension WithdrawViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(WithdrawImageCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setUp(item: indexPath.item)
        return cell
    }
}
