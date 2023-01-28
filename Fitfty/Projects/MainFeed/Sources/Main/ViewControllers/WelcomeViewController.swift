//
//  WelcomeViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public class WelcomeViewController: UIViewController {

    private weak var coordinator: WelcomeCoordinatorInterface?
    private var viewModel: WelcomeViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: WelcomeCoordinatorInterface, viewModel: WelcomeViewModel) {
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
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.weather.image
        imageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return imageView
    }()
}

private extension WelcomeViewController {
    
    func setUp() {
        setUpBackgroundView()
        setUpLayout()
    }
    
    func setUpBackgroundView() {
        view.backgroundColor = .white
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 250)
        gradientLayer.colors = [CommonAsset.Colors.ft.color.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.1]
        gradientLayer.cornerRadius = 15
        view.layer.addSublayer(gradientLayer)
    }
    
    func setUpLayout() {
        view.addSubviews(weatherImageView)
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            weatherImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
