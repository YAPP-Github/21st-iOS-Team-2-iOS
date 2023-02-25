//
//  IntroViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common
import Core

final public class AuthIntroViewController: UIViewController {
    private let coordinator: AuthCoordinatorInterface
    
    private let titleLabel = UILabel()
    private let nextButton = FitftyButton(style: .enabled, title: Style.NextButton.text)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(coordinator: AuthCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        configure()
        autoScroll()
    }
    
    private func configure() {
        configureTitleLabel()
        configureNextButton()
        configureCollectionView()
        configureButtonTarget()
    }
    
    private func configureButtonTarget() {
        nextButton.setButtonTarget(target: self, action: #selector(didTouchNextButton))
    }
    
    private func configureTitleLabel() {
        view.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Style.TitleLabel.margin),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        titleLabel.numberOfLines = Style.TitleLabel.numberOfLines
        titleLabel.text = Style.TitleLabel.text
        titleLabel.textColor = Style.TitleLabel.textColor
        titleLabel.font = Style.TitleLabel.font
        titleLabel.setTextWithLineHeight(lineHeight: Style.TitleLabel.lingHeight)
        titleLabel.textAlignment = Style.TitleLabel.textAlignment
    }
    
    private func configureNextButton() {
        view.addSubviews(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Style.NextButton.margin.left),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Style.NextButton.margin.right),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Style.NextButton.margin.bottom)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
        
        collectionView.register(WithdrawImageCell.self)
        collectionView.isUserInteractionEnabled = false
        collectionView.dataSource = self
    }
    
    @objc
    private func didTouchNextButton() {
        coordinator.pushAuthView()
    }
    
    private func autoScroll() {
        let contentOffsetX = collectionView.contentOffset.x
        let afterContentOffsetX = contentOffsetX + 1.5
        
        if afterContentOffsetX > 600 {
            return
        }
        
        UIView.animate(withDuration: 0.001, delay: 0, options: .curveEaseInOut, animations: { [weak self] () -> Void in
            self?.collectionView.contentOffset = CGPoint(x: afterContentOffsetX, y: 0)
        }, completion: { [weak self] _ in
            self?.autoScroll()
        })
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (_, _) -> NSCollectionLayoutSection? in
            return self?.introSectionLayout()
        }
    }
    
    private func introSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(295),
            heightDimension: .absolute(337)
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

extension AuthIntroViewController: UICollectionViewDataSource {
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

private extension AuthIntroViewController {
    enum Style {
        enum TitleLabel {
            static let margin: CGFloat = 120
            static let numberOfLines = 0
            static let lingHeight: CGFloat = 44.8
            static let text = "오늘 날씨엔 어떤 코디?\n더 이상 고민고민하지마"
            static let textColor = CommonAsset.Colors.gray08.color
            static let textAlignment: NSTextAlignment = .center
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum NextButton {
            static let margin: UIEdgeInsets = .init(top: 64, left: 20, bottom: 100, right: 20)
            static let text = "계속하기"
        }
    }
}
