//
//  ThreeViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

protocol ThreeViewControllerNavigation: BaseCoordinatorProtocol {
    // Add here functions to navigate away from this screen, to ask the Coordinator to show another screen
    func showStep2()
}

class ThreeViewController: BaseViewController {

    weak var coordinator: ThreeViewControllerNavigation?
    
    // MARK: - Private Properties
    deinit {
        print(self)
    }
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.viewControllers.first
        
        addBackPresentRootViewController()
        
        title = "three"
        view.backgroundColor = .purple
        
        let btn = UIButton()
        btn.setTitle("toRoot", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 50, height: 50)
        btn.addTarget(self, action: #selector(toRoot), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn2 = UIButton()
        btn2.setTitle("showStep2", for: .normal)
        btn2.frame = .init(x: 200, y: 100, width: 50, height: 50)
        btn2.addTarget(self, action: #selector(showStep2), for: .touchUpInside)
        view.addSubview(btn2)
    }
    
    // MARK: - Internal Funcs
    @objc func toRoot() {
        self.coordinator?.toRoot()
    }
    
    @objc func showStep2() {
        self.coordinator?.showStep2()
    }
}
