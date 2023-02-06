//
//  AddressViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine
import Common
import Core

public final class AddressViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = .init()
    
    private let coordinator: AddressCoordinatorInterface
    private let viewModel: AddressViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
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
        searchController.dismiss(animated: true)
        coordinator.finished()
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<AddressSectionKind, Address>?
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .darkGray
        searchController.searchBar.placeholder = "지금 어디에 계세요?"
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AddressCell.self)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var cancelButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "닫기")
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
    
    private lazy var selectButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "선택")
        button.addTarget(self, action: #selector(didTapSelectButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "뒤로가기")
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색어를 입력해주세요."
        label.textColor = CommonAsset.Colors.gray04.color
        label.font = FitftyFont.appleSDBold(size: 18).font
        return label
    }()
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white, alpha: 1)
        loadingView.startAnimating()
        loadingView.alpha = 0
        return loadingView
    }()
}

private extension AddressViewController {
    
    func bind() {
        viewModel.state.sinkOnMainThread(receiveValue: { [weak self] state in
            switch state {
            case .isEmpty(let isEmpty):
                self?.emptyLabel.isHidden = isEmpty == false
                
            case .sections(let sections):
                self?.applySnapshot(sections)
                
            case .isLoading(let isLoading):
                if isLoading {
                    self?.loadingIndicatorView.startAnimating()
                    self?.loadingIndicatorView.alpha = 1
                }
                
            case .errorMessage(let message):
                self?.showAlert(message: message)
                
            case .weather(let weatherNow, let address):
                self?.updateAddressInfo(weather: weatherNow, address: address)
                
            case .completed(let completed):
                guard completed else {
                    return
                }
                self?.searchController.dismiss(animated: true)
                self?.coordinator.dismiss()
            }
        }).store(in: &cancellables)
    }
    
    func setUp() {
        setUpNavigationBar()
        setUpLayout()
        setUpDataSource()
    }
    
    func setUpNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 28).font ?? UIFont.systemFont(ofSize: 28)]
        navigationItem.title = "주소를 설정해주세요."
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(
            cancelButton, buttonStackView, collectionView, addressInfoView, emptyLabel, loadingIndicatorView
        )
        let cancelButtonBottom = cancelButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26
        )
        let buttonsBottom = buttonStackView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -26
        )
        let loadingViewBottom = loadingIndicatorView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90
        )
        cancelButtonBottom.priority = .init(999)
        buttonsBottom.priority = .init(999)
        loadingViewBottom.priority = .init(999)
        NSLayoutConstraint.activate([
            cancelButtonBottom,
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 64),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addressInfoView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            addressInfoView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            addressInfoView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            addressInfoView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonStackView.topAnchor.constraint(equalTo: addressInfoView.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsBottom,
            emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingIndicatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingViewBottom
        ])
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AddressSectionKind, Address>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, address in
                let section = AddressSectionKind(index: indexPath.section)
                switch section {
                case .address:
                    let cell = collectionView.dequeueReusableCell(AddressCell.self, for: indexPath)
                    cell?.setUp(address.formatted())
                    let text = self?.searchController.searchBar.text?.replacingOccurrences(of: " ", with: ", ")
                    cell?.highlighted(text ?? "")
                    return cell
                    
                default: return UICollectionViewCell()
                }
            })
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot(_ sections: [AddressSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<AddressSectionKind, Address>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = AddressSectionKind(index: sectionNumber)
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
        searchController.dismiss(animated: true)
        coordinator.dismiss()
    }
    
    @objc func didTapSelectButton(_ sender: UIButton) {
        viewModel.input.didTapSelected()
    }
    
    @objc func didTapBackButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.addressInfoView.alpha = 0
            self?.buttonStackView.alpha = 0
            self?.searchController.searchBar.alpha = 1
            self?.loadingIndicatorView.alpha = 1
            self?.loadingIndicatorView.stopAnimating()
            self?.view.layoutIfNeeded()
        }, completion: nil)
        searchController.searchBar.isUserInteractionEnabled = true
    }
    
    func updateAddressInfo(weather: WeatherNow, address: String) {
        addressInfoView.reset()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.addressInfoView.isHidden = false
            self?.addressInfoView.alpha = 1
            self?.addressInfoView.setUp(
                address: address,
                temp: weather.temp,
                icon: weather.forecast.icon
            )
            self?.buttonStackView.alpha = 1
            self?.loadingIndicatorView.alpha = 0
            self?.searchController.searchBar.alpha = 0
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension AddressViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let address = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        viewModel.input.didTapAddress(address)
        searchController.searchBar.isUserInteractionEnabled = false
    }
    
}

extension AddressViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchBar.text?.isEmpty == false else {
            return
        }
        viewModel.input.search(text: searchText)
    }
}
