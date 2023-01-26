//
//  MyPostBottomSheetViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/26.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class MyPostBottomSheetViewController: UIViewController {
    
    private var coordinator: MyProfileCoordinatorInterface
    private let myPostBottomSheetView = MyPostBottomSheetView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setConstratintsLayout()
        setButtonAction()
    }
    
    public init(coordinator: MyProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstratintsLayout() {
        view.addSubviews(myPostBottomSheetView)
        NSLayoutConstraint.activate([
            myPostBottomSheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myPostBottomSheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myPostBottomSheetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            myPostBottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44)
        ])
    }
    
    private func setButtonAction() {
        myPostBottomSheetView.setActionDeleteButton(self, action: #selector(didTapDeleteButton))
        myPostBottomSheetView.setActionModifyButton(self, action: #selector(didTapModifyButton))
    }
    
    @objc func didTapModifyButton(_ sender: Any?) {
        coordinator.dismiss()
        coordinator.showUploadCody()
    }
    
    @objc func didTapDeleteButton(_ sender: Any?) {
        coordinator.dismiss()
        coordinator.popToRoot()
    }

}
