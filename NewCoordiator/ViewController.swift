//
//  ViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/23.
//

import UIKit

class ViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    
    // MARK: - Private Properties
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton()
        btn.setTitle("showTutorial", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 50, height: 50)
        btn.addTarget(self, action: #selector(showTutorial), for: .touchUpInside)
        view.addSubview(btn)
    }
    
    // MARK: - Internal Funcs
    
    @objc func showTutorial() {
        self.coordinator?.showTutorial()
    }
}

