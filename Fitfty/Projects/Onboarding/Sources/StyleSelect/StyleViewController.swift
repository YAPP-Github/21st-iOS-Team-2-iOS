//
//  StyleViewController.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

final public class StyleViewController: UIViewController {
    private let coordinator: OnboardingCoordinatorInterface
    
    private let contentView = StyleView()
    private let viewModel: StyleViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Int, StyleTag>?
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let nextButton = FitftyButton(style: .disabled, title: "선택 완료")
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    public init(viewModel: StyleViewModel, coordinator: OnboardingCoordinatorInterface) {
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
        configureNavigationBar()
        configureContentView()
        configureNextButton()
        configureCollectionView()
        configureDataSource()
        applySnapshot()
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.nextButton.setStyle(isEnabled ? .enabled : .disabled)
                    
                case .pushMainFeedView:
                    self?.coordinator.pushMainFeedView()
                    
                case .showErrorAlert(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, StyleTag>()
        snapshot.appendSections([0])
        snapshot.appendItems(StyleTag.tags())
        snapshot.appendSections([1])
        snapshot.appendItems(StyleTag.otherTags())
        dataSource?.apply(snapshot)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, StyleTag>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(FeedSettingCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                cell.tag = indexPath.item
                cell.setUp(style: item, title: item.styleTagKoreanString, isSelected: false)
                return cell
            }
        )
    }
    
    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func configureContentView() {
        view.addSubviews(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureNextButton() {
        view.addSubviews(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        nextButton.layer.cornerRadius = 0
        nextButton.setHeight(80)
        nextButton.setButtonTarget(target: self, action: #selector(didTapNextButton))
    }
    
    private func configureCollectionView() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
        
        collectionView.register(FeedSettingCell.self)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
    }
    
    @objc
    private func didTapNextButton() {
        viewModel.didTapNextButton()
    }
    
    @objc
    private func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.pop()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (_, _) -> NSCollectionLayoutSection? in
            self?.styleTagLayout()
        }
    }
    
    private func styleTagLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1),
            heightDimension: .absolute(43)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8
        
        return section
    }
}

extension StyleViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FeedSettingCell else {
            return
        }
        cell.toggle()
        viewModel.didSelectItem(style: cell.retrieveStyle(),
                                isSelected: cell.retrieveState())
    }
}
