//
//  AddressViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class AddressViewController: UIViewController {
    
    enum Section {
        
        case address
        
        init?(index: Int) {
            switch index {
            case 0: self = .address
            default: return nil
            }
        }
        
    }
    
    private weak var coordinator: AddressCoordinatorInterface?
    private var viewModel: AddressViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: AddressCoordinatorInterface, viewModel: AddressViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator?.dismiss()
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .darkGray
        searchController.searchBar.placeholder = "지금 어디에 계세요?"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AddressCell.self)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("닫기", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = FitftyFont.SFProDisplayBold(size: 18).font
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addressInfoView: AddressInfoView = {
        let view = AddressInfoView()
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 8)
        stackView.backgroundColor = .white
        stackView.addArrangedSubviews(backButton, selectButton)
        stackView.alpha = 0
        return stackView
    }()
    
    private lazy var selectButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = FitftyFont.SFProDisplayBold(size: 18).font
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.addTarget(self, action: #selector(didTapSelectButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = FitftyFont.SFProDisplayBold(size: 18).font
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 64).isActive = true
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
}

private extension AddressViewController {
    
    func setUp() {
        setUpNavigationBar()
        setUpLayout()
        setUpDataSource()
        applySnapshot()
    }
    
    func setUpNavigationBar() {
        navigationItem.title = "주소를 설정해주세요."
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(cancelButton, collectionView, addressInfoView, buttonStackView)
        let cancelButtonBottom = cancelButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26
        )
        let buttonsBottom = buttonStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26
        )
        cancelButtonBottom.priority = .defaultLow
        buttonsBottom.priority = .defaultLow
        NSLayoutConstraint.activate([
            cancelButtonBottom,
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 64),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressInfoView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            addressInfoView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            addressInfoView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            addressInfoView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 64),
            buttonsBottom
        ])
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let section = Section(index: indexPath.section)
                switch section {
                case .address:
                    let cell = collectionView.dequeueReusableCell(AddressCell.self, for: indexPath)
                    return cell
                    
                default: return UICollectionViewCell()
                }
            })
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.address])
        snapshot.appendItems(Array(0...20).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(index: sectionNumber)
            switch section {
            case .address: return self?.addressSectionLayout()
            default: return nil
            }
        }
    }
    
    func addressSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 5, leading: .zero, bottom: .zero, trailing: .zero)
        return section
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        print(#function)
        coordinator?.dismiss()
    }
    
    @objc func didTapSelectButton(_ sender: UIButton) {
        print(#function)
        coordinator?.dismiss()
    }
    
    @objc func didTapBackButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.addressInfoView.alpha = 0
            self?.buttonStackView.alpha = 0
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension AddressViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.addressInfoView.isHidden = false
            self?.addressInfoView.alpha = 1
            self?.addressInfoView.setUp(
                address: "서울시, 강남구, 역삼 1동",
                temp: 12,
                icon: UIImage(systemName: "cloud")?
                    .withRenderingMode(.alwaysOriginal)
                    .withTintColor(.black)
            )
            self?.buttonStackView.alpha = 1
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}
