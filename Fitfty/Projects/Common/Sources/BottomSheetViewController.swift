//
//  AddressViewController.swift
//  MainFeed
//
//  Created by Ari on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public final class BottomSheetViewController: UIViewController {
    
    public enum ModalStyle {
        
        case large
        case medium
        case small
        case custom(CGFloat)
        
        var topConstant: CGFloat {
            switch self {
            case .large: return UIScreen.main.bounds.height * 0.12
            case .medium: return UIScreen.main.bounds.height * 0.45
            case .small: return UIScreen.main.bounds.height * 0.84
            case .custom(let height): return UIScreen.main.bounds.height - height
            }
        }
        
    }
    
    private weak var contentViewController: UIViewController?
    private let style: ModalStyle
    
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private var bottomSheetPanMinTopConstant: CGFloat = 30.0
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.alpha = 0
        return view
    }()
    
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.addSubviews(contentViewController?.view ?? UIView())
        return view
    }()
    
    public init(
        style: ModalStyle,
        contentViewController: UIViewController
    ) {
        self.style = style
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
}

private extension BottomSheetViewController {
    
    func setUp() {
        setUpContentView()
        setUpLayout()
        setUpGestureRecognizer()
    }
    
    func setUpContentView() {
        guard let contentViewController = contentViewController else {
            return
        }
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            contentViewController.view.topAnchor.constraint(equalTo: bottomSheetView.topAnchor),
            contentViewController.view.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
    }
    
    func setUpLayout() {
        view.backgroundColor = .clear
        view.addSubviews(dimmedView, bottomSheetView)
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: view.bounds.height
        )
        bottomSheetViewTopConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            bottomSheetViewTopConstraint,
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUpGestureRecognizer() {
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView(_:)))
        dimmedView.addGestureRecognizer(dimmedTap)
        dimmedView.isUserInteractionEnabled = true
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(pannedView(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    @objc func didTapDimmedView(_ gestureRecognizer: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func pannedView(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            if translation.y + bottomSheetPanMinTopConstant >= bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
            dimmedView.alpha = dimAlphaWithBottomSheetTopConstraint(
                value: bottomSheetViewTopConstraint.constant
            )
        case .ended:
            if velocity.y > 1500 {
                dismiss()
                return
            }
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom + view.safeAreaInsets.top
            if translation.y >= ((safeAreaHeight + bottomPadding) - style.topConstant) {
                dismiss()
                return
            } else {
                showBottomSheet()
            }
        default:
            break
        }
    }
    
    func dimAlphaWithBottomSheetTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        let topPadding = view.safeAreaInsets.top
        
        let fullDimPosition = (safeAreaHeight + bottomPadding + topPadding + style.topConstant) / 2.5
        if value < fullDimPosition {
            return fullDimAlpha
        }
        let noDimPosition = safeAreaHeight + bottomPadding
        if value > noDimPosition {
            return 0.0
        }
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    
    func dismiss(_ completion: (() -> Void)? = nil) {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom + view.safeAreaInsets.top
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            self?.dimmedView.alpha = 0.0
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            if self?.presentingViewController != nil {
                self?.contentViewController?.willMove(toParent: nil)
                self?.contentViewController?.removeFromParent()
                self?.contentViewController?.view.removeFromSuperview()
                let navigationController = self?.contentViewController as? UINavigationController
                navigationController?.popToRootViewController(animated: false)
                navigationController?.topViewController?.removeFromParent()
                self?.contentViewController = nil
                self?.dismiss(animated: false, completion: completion)
            }
        }
    }
    
    func showBottomSheet() {
        bottomSheetViewTopConstraint.constant = style.topConstant
        UIView.animate(
            withDuration: 0.55,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1,
            animations: { [weak self] in
            self?.dimmedView.alpha = 0.7
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

public protocol BottomSheetViewControllerDelegate: AnyObject {
    
    func dismissBottomSheet(_ completion: (() -> Void)?)
}

extension BottomSheetViewController: BottomSheetViewControllerDelegate {
    public func dismissBottomSheet(_ completion: (() -> Void)?) {
        dismiss(completion)
    }
}
