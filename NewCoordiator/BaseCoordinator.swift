//
//  BaseCoordinator.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

protocol BaseCoordinatorProtocol: AnyObject {
    func toRoot()
}

class BaseCoordinator: Coordinator, BaseViewControllerNavigation {
    let components: CoordinatorComponents
    
    init(components: CoordinatorComponents) {
        self.components = components
    }
    
    func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup) {
        
    }
    
    func backButtonTrigger() {
        self.components.parentCoordinator?.dismissChildCoordinator() {
            print("done")
        }
    }
    
    func toRoot() {
        self.dismissToRoot()
    }
}
