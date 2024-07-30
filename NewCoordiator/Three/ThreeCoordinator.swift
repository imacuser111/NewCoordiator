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
    
//    init(components: CoordinatorComponents) {
//        self.components = components
//    }
    
    override func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        components.mainViewController.transitioningDelegate = self
        
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
        self.pushViewController(vc, animated: true)
    }
}

extension ThreeCoordinator: ThreeStep2ViewControllerNavigation {
    func closeTutorial() {
        self.dismissChildCoordinator(animated: false)
    }
    
    func showFour() {
        let coordinator = FourCoordinator(components: .init(parentCoordinator: self))
//        coordinator.delegate = self
        self.present(childCoordinator: coordinator)
    }
}
