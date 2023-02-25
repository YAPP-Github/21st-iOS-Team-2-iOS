//
//  CodyCell.swift
//  MainFeed
//
//  Created by Ari on 2022/12/06.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Combine
import Common
import Core
import Kingfisher

final class CodyCell: UICollectionViewCell {
    
    private var viewModel: CodyCellViewModel?
    private var cancellables: Set<AnyCancellable> = .init()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 256, height: 256)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height)
    }
    
    func addProfileViewGestureRecognizer(_ target: Any?, action: Selector) {
        profileStackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    private lazy var viewsInfoView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .leading, distribution: .fill, spacing: 4)
        stackView.addArrangedSubviews(viewsIconImageView, viewsCountLabel)
        return stackView
    }()
    
    private lazy var viewsIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.eye.image
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()
    
    private lazy var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FitftyFont.SFProDisplayBold(size: 12).font
        label.text = "1245".insertComma
        return label
    }()
    
    private lazy var codyImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        image.image = CommonAsset.Images.sample.image
        let dimmedView = UIView()
        dimmedView.backgroundColor = .black.withAlphaComponent(0.4)
        image.addSubviews(dimmedView)
        dimmedView.leadingAnchor.constraint(equalTo: image.leadingAnchor).isActive = true
        dimmedView.trailingAnchor.constraint(equalTo: image.trailingAnchor).isActive = true
        dimmedView.heightAnchor.constraint(equalToConstant: 61).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: image.bottomAnchor).isActive = true
        return image
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(profileImageView, nameLabel)
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = CommonAsset.Images.profileDummy.image
        image.clipsToBounds = true
        image.layer.cornerRadius = 16
        image.widthAnchor.constraint(equalToConstant: 32).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = "iloveiso2"
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.bookmark.image, for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.addTarget(self, action: #selector(didTapBookmarkButton(_:)), for: .touchUpInside)
        return button
    }()
}

extension CodyCell {
    
    func setUp(cody: CodyResponse) {
        viewModel = .init(
            fitftyRepository: DefaultFitftyRepository(),
            userManager: DefaultUserManager.shared,
            cody: cody
        )
        bind()
        viewModel?.input.fetch()
    }
    
    func bind() {
        viewModel?.state.sinkOnMainThread(receiveValue: { [weak self] state in
            switch state {
            case .cody(let cody):
                if let url = URL(string: cody.filePath) {
                    let processor = DownsamplingImageProcessor(
                        size: CGSize(
                            width: self?.codyImageView.bounds.size.width ?? 256,
                            height: self?.codyImageView.bounds.size.height ?? 256
                        )
                    )
                    self?.codyImageView.kf.setImage(
                        with: url, options: [
                            .processor(processor),
                            .transition(.fade(0.5)),
                            .scaleFactor(UIScreen.main.scale),
                            .cacheOriginalImage
                    ])
                }
                if let profileURL = cody.profilePictureUrl, let url = URL(string: profileURL) {
                    self?.profileImageView.kf.setImage(with: url)
                }
                self?.viewsCountLabel.text = cody.views.description
                self?.nameLabel.text = cody.nickname
                self?.bookmarkButton.setImage(
                    cody.bookmarked ? CommonAsset.Images.bookmarkFill.image : CommonAsset.Images.bookmark.image, for: .normal
                )
                
            case .bookmarkState(let isBookmark):
                self?.bookmarkButton.setImage(
                    isBookmark ? CommonAsset.Images.bookmarkFill.image : CommonAsset.Images.bookmark.image, for: .normal
                )
            }
        }).store(in: &cancellables)
    }
    
}

private extension CodyCell {
    
    func reset() {
        codyImageView.kf.cancelDownloadTask()
        profileImageView.kf.cancelDownloadTask()
        codyImageView.image = nil
        profileImageView.image = CommonAsset.Images.profileDummy.image
        viewsCountLabel.text = nil
        nameLabel.text = nil
    }
    
    func configure() {
        contentView.addSubviews(codyImageView, profileStackView, viewsInfoView, bookmarkButton)
        NSLayoutConstraint.activate([
            codyImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            codyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            codyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            codyImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: codyImageView.leadingAnchor, constant: 12),
            profileStackView.bottomAnchor.constraint(equalTo: codyImageView.bottomAnchor, constant: -15),
            viewsInfoView.topAnchor.constraint(equalTo: codyImageView.topAnchor, constant: 12),
            viewsInfoView.leadingAnchor.constraint(equalTo: codyImageView.leadingAnchor, constant: 12),
            bookmarkButton.bottomAnchor.constraint(equalTo: codyImageView.bottomAnchor, constant: -8),
            bookmarkButton.trailingAnchor.constraint(equalTo: codyImageView.trailingAnchor, constant: -8)
        ])
    }
    
    @objc func didTapBookmarkButton(_ sender: UIButton) {
        viewModel?.input.didTapBookmark()
    }
}
