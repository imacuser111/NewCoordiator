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
}

final class ThreeStep2ViewController: UIViewController {
    
    weak var coordinator: ThreeStep2ViewControllerNavigation?
    
    let collectionView = UICollectionView()
    
    // MARK: - Private Properties
    deinit {
        print(self)
    }
    
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent {
            self.coordinator?.closeTutorial()
        }
    }
    
    // MARK: - Internal Funcs
    @objc func toRoot() {
        self.coordinator?.toRoot()
    }
}
