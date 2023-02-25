//
//  ProfileSettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine
import Kingfisher

import Common

public final class ProfileSettingViewController: UIViewController {
    
    private weak var coordinator: ProfileSettingCoordinatorInterface?
    private var viewModel: ProfileSettingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(coordinator: ProfileSettingCoordinatorInterface, viewModel: ProfileSettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUp()
        bind()
        
        viewModel.getUserProfile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator?.dismiss()
    }
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "프로필 설정", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    private lazy var profileView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 12)
        stackView.addArrangedSubviews(profileImageView, editProfileButton)
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 104).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 104 / 2
        return imageView
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 사진 변경", for: .normal)
        button.setTitleColor(CommonAsset.Colors.gray05.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        button.layer.borderWidth = 1
        button.layer.borderColor = CommonAsset.Colors.gray01.color.cgColor
        button.layer.cornerRadius = 16
        button.widthAnchor.constraint(equalToConstant: 121).isActive = true
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        button.addTarget(self, action: #selector(didTapEditProfileButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var introductionView: UserInputView = {
        let inputView = UserInputView(title: "한 줄 소개", textField: introductionTextField)
        return inputView
    }()
    
    private lazy var introductionTextField: FitftyTextField = {
        let textFiled = FitftyTextField(style: .normal, placeHolderText: "30자 이내 한 줄 소개를 입력해주세요.")
        textFiled.becomeFirstResponder()
        return textFiled
    }()
    
    private lazy var saveButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "수정하기")
        button.setButtonTarget(target: self, action: #selector(didTapSaveButton(_:)))
        return button
    }()
}

private extension ProfileSettingViewController {
    
    func setUp() {
        setUpLayout()
    }
    
    func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .updateProfileMessage(let text):
                    self?.introductionTextField.text = text
                    
                case .updateProfileImage(let imageString):
                    if let url = URL(string: imageString ?? "") {
                        self?.profileImageView.kf.setImage(
                            with: url,
                            options: [.transition(.fade(0.5))]
                        )
                    }
                    
                case .showErrorAlert(let error):
                    self?.showAlert(message: error.localizedDescription)
                    
                case .dismiss:
                    self?.coordinator?.dismiss()
                }
            }
            .store(in: &cancellables)
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(navigationBarView, profileView, introductionView, saveButton)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            introductionView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 24),
            introductionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            introductionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.topAnchor.constraint(equalTo: introductionView.bottomAnchor, constant: 32),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didTapSaveButton(_ sender: UITapGestureRecognizer) {
        viewModel.didTapSaveButton(message: introductionTextField.text)
    }
    
    @objc func didTapEditProfileButton(_ sender: UIButton) {
        coordinator?.showImagePicker(self)
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        coordinator?.dismiss()
    }
    
}

extension ProfileSettingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        guard let selectedImage = editedImage ?? originalImage else {
            return
        }
        profileImageView.image = selectedImage
        viewModel.didTapEditProfileImage(imageData: selectedImage.jpegData(compressionQuality: 0.35))
        picker.dismiss(animated: true)
    }
    
}
