//
//  ThreeStep2ViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

protocol ThreeStep2ViewControllerNavigation: BaseCoordinatorProtocol {
    // Add here functions to navigate away from this screen, to ask the Coordinator to show another screen
    func closeTutorial()
    
    func showFour()
}

final class ThreeStep2ViewController: BaseViewController {
    
    weak var coordinator: ThreeStep2ViewControllerNavigation?
    
    // MARK: - Private Properties
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "ThreeStep2"
        view.backgroundColor = .purple
        
        let btn = UIButton()
        btn.setTitle("toRoot", for: .normal)
        btn.frame = .init(x: 100, y: 100, width: 50, height: 50)
        btn.addTarget(self, action: #selector(toRoot), for: .touchUpInside)
        view.addSubview(btn)
        
        let btn2 = UIButton()
        btn2.setTitle("showFour", for: .normal)
        btn2.frame = .init(x: 200, y: 100, width: 50, height: 50)
        btn2.addTarget(self, action: #selector(showFour), for: .touchUpInside)
        view.addSubview(btn2)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // 偵測按下nav back鍵
//        if self.isMovingFromParent {}
//    }
    
    // MARK: - Internal Funcs
    @objc func toRoot() {
        self.coordinator?.toRoot()
    }
    
    @objc func showFour() {
        self.coordinator?.showFour()
    }
}
