//
//  PersonalInfoViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class PersonalInfoViewController: UIViewController {
    
    private weak var coordinator: PersonalInfoCoordinatorInterface?
    private var viewModel: PersonalInfoViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<PersonalInfoSection, Setting>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: PersonalInfoCoordinatorInterface, viewModel: PersonalInfoViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = FitftyFont.appleSDMedium(size: 15).font
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton(_:)), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 67).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(PersonalInfoInputCell.self)
        collectionView.register(SettingCell.self)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var contactTextField: FitftyTextField = {
        let textFiled = FitftyTextField(style: .normal, placeHolderText: "010-1234-5678")
        textFiled.font = FitftyFont.appleSDSemiBold(size: 16).font
        return textFiled
    }()
    
    private lazy var dateTextField: FitftyTextField = {
        let textFiled = FitftyTextField(style: .normal, placeHolderText: "YYMMDD")
        textFiled.font = FitftyFont.appleSDSemiBold(size: 16).font
        return textFiled
    }()
    
    private lazy var emailTextField: FitftyTextField = {
        let textFiled = FitftyTextField(style: .normal, placeHolderText: "fitfty@gmail.com")
        textFiled.font = FitftyFont.appleSDSemiBold(size: 16).font
        return textFiled
    }()
    
    private lazy var textfieldList: [FitftyTextField] = {
        return [contactTextField, dateTextField, emailTextField]
    }()
    
}

private extension PersonalInfoViewController {
    
    func setUp() {
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
        let saveButton = UIBarButtonItem(customView: saveButton)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 28).font ?? UIFont.systemFont(ofSize: 28)]
        navigationItem.title = "개인 정보 설정"
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator?.finished()
    }
    
    @objc func didTapSaveButton(_ sender: UITapGestureRecognizer) {
        coordinator?.finished()
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
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
            let section = PersonalInfoSection(index: sectionNumber)
            switch section {
            case .info: return self?.infoListLayout()
            case .etc: return self?.etcLayout()
            default: return nil
            }
        }
    }
    
    func infoListLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(90)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 60, trailing: 20)
        section.interGroupSpacing = 30
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
                    heightDimension: .absolute(8)
                ),
                elementKind: FooterView.className, alignment: .bottom)
        ]
        return section
    }
    
    func etcLayout() -> NSCollectionLayoutSection? {
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
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<PersonalInfoSection, Setting>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                let section = PersonalInfoSection(index: indexPath.section)
                switch section {
                case .info:
                    guard let cell = collectionView.dequeueReusableCell(
                        PersonalInfoInputCell.self,
                        for: indexPath
                    ), let textField = self?.textfieldList[indexPath.item] else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(title: item.title, textField: textField)
                    return cell
                    
                case .etc:
                    guard let cell = collectionView.dequeueReusableCell(SettingCell.self, for: indexPath) else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(item: item)
                    return cell
                default: return UICollectionViewCell()
                }
                
            })
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case FooterView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FooterView.className,
                    for: indexPath
                )
            default: return UICollectionReusableView()
            }
        }
        collectionView.dataSource = dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<PersonalInfoSection, Setting>()
        snapshot.appendSections([.info])
        snapshot.appendItems(Setting.info())
        snapshot.appendSections([.etc])
        snapshot.appendItems(Setting.etc())
        dataSource?.apply(snapshot)
    }
}

extension PersonalInfoViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        switch item {
        case .logout:
            print(item)
            
        case .membershipWithdrawal:
            print(item)
            
        default: break
        }
    }
    
}
