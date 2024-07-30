//
//  FourViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/30.
//

import UIKit

protocol FourViewControllerNavigation: BaseCoordinatorProtocol {
    // Add here functions to navigate away from this screen, to ask the Coordinator to show another screen
}

class FourViewControllerController: BaseViewController {

    weak var coordinator: FourViewControllerNavigation?
    
    // MARK: - Private Properties
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackPresentRootViewController()
        
        title = "three"
        view.backgroundColor = .blue
        
        let btn = UIButton()
        btn.setTitle("toRoot", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 50, height: 50)
        btn.addTarget(self, action: #selector(toRoot), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    // MARK: - Internal Funcs
    @objc func toRoot() {
        self.coordinator?.toRoot()
    }
}
