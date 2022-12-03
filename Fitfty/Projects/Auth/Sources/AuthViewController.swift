//
//  Auth.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit

final public class AuthViewController: UIViewController {
    
    public weak var coordinator: AuthCoordinatorInterface?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
