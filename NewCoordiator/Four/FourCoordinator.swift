//
//  FourCoordinator.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/30.
//

import UIKit

protocol FourCoordinatorDelegate: AnyObject {
    func dismissTutorial()
}

class FourCoordinator: BaseCoordinator {
//    let components: CoordinatorComponents
    
    weak var delegate: ThreeCoordinatorDelegate?
    
//    init(components: CoordinatorComponents) {
//        self.components = components
//    }
    
    override func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        components.mainViewController.transitioningDelegate = self
        
        let threeVC = FourViewControllerController()
        threeVC.coordinator = self
        threeVC.backDelegate = self
        components.mainViewController.setInitialViewController(threeVC)
        components.mainViewController.modalPresentationStyle = .custom
    }
}

extension FourCoordinator: FourViewControllerNavigation {}
