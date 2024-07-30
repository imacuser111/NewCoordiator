//
//  File.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/23.
//

import UIKit

protocol TutorialCoordinatorDelegate: AnyObject {
    func dismissTutorial()
}

class TutorialCoordinator: Coordinator {
    let components: CoordinatorComponents
    weak var delegate: TutorialCoordinatorDelegate?
    
    deinit {
        print(self)
    }
    
    init(components: CoordinatorComponents) {
        self.components = components
    }
    
    func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        
        let step1VC = TutoStep1ViewController()
        step1VC.coordinator = self
        components.mainViewController.setInitialViewController(step1VC)
        components.mainViewController.modalPresentationStyle = .custom
    }
}

extension TutorialCoordinator: TutoStep1ViewControllerNavigation {
    func showTutorialStep2() {
        let step2VC = TutoStep2ViewController()
        step2VC.coordinator = self
        self.pushViewController(step2VC, animated: true)
    }
}

extension TutorialCoordinator: TutoStep2ViewControllerNavigation {
    func closeTutorial() {
        self.delegate?.dismissTutorial()
    }
    
    func pushTreeCoordinator() {
        let coordinator = ThreeCoordinator(components: .init(parentCoordinator: self))
//        coordinator.delegate = self
        self.present(childCoordinator: coordinator)
    }
}
