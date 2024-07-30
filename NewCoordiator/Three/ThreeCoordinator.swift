//
//  ThreeCoordinator.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

protocol ThreeCoordinatorDelegate: AnyObject {
    func dismissTutorial()
}

class ThreeCoordinator: BaseCoordinator {
//    let components: CoordinatorComponents
    
    weak var delegate: TutorialCoordinatorDelegate?
    
    deinit {
        print(self)
    }
    
//    init(components: CoordinatorComponents) {
//        self.components = components
//    }
    
    override func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        let threeVC = ThreeViewController()
        threeVC.coordinator = self
        threeVC.backDelegate = self
        components.mainViewController.setInitialViewController(threeVC)
        components.mainViewController.modalPresentationStyle = .custom
    }
}

extension ThreeCoordinator: ThreeViewControllerNavigation {
    func showStep2() {
        let vc = ThreeStep2ViewController()
        vc.coordinator = self
        components.mainViewController.pushViewController(vc, animated: true)
    }
}

extension ThreeCoordinator: ThreeStep2ViewControllerNavigation {
    func closeTutorial() {
        self.dismissChildCoordinator(animated: false)
    }
}
