//
//  AppCoordinatorViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

class AppCoordinator: Coordinator {
    let components = CoordinatorComponents()
    
    func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        let mainVC = ViewController()
        mainVC.coordinator = self
        modalSetup.setInitialViewController(mainVC)
    }
    
    func showTutorial() {
        let tutorialCoordinator = TutorialCoordinator(components: .init(parentCoordinator: self))
        tutorialCoordinator.delegate = self
        present(childCoordinator: tutorialCoordinator)
    }
}

extension AppCoordinator: TutorialCoordinatorDelegate {
    func dismissTutorial() {
        dismissChildCoordinator()
    }
}
