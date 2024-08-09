//
//  BaseCoordinator.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/23.
//

//  Coordinator.swift

import UIKit

public protocol Coordinator: AnyObject {
    
    var components: CoordinatorComponents { get }

    /// Set up here everything that needs to happen just before the Coordinator is presented
    ///
    /// - Parameter modalSetup: A parameter you can use to customize the default mainViewController's
    ///                         presentation style (e.g. `modalPresentationStyle`, etc), and to set the initial
    ///                         ViewController of the Coordinator's UINavigationController (if you didn't
    ///                         already set it in the init() when instantiating CoordinatorComponents).
    ///
    /// - Attention: Don't call this method directly. It will be called automatically when you call
    ///              `present(childCoordinator:animated:completion:)`
    func start(modalSetup: ViewControllerInitialSetup & ViewControllerModalSetup)

    /// ⬆️ Present a child Coordinator modally
    /// - Note: You can pass an overrideModalSetup closure if you need to customize the
    ///         modalPresentationStyle/modalTransitionStyle etc for that modal presentation
    func present(childCoordinator coordinator: Coordinator, animated: Bool,
                 overrideModalSetup: ((ViewControllerModalSetup) -> Void)?, completion: (() -> Void)?)
    /// ⬇️ Dismiss the top modal child Coordinator
    func dismissChildCoordinator(animated: Bool, completion: (() -> Void)?)

    /// ➡️ Push a ViewController on the current coordinator's NavigationController
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    /// ⬅️ Pop the top ViewController from the current coordinator's NavigationController
    func popViewController(animated: Bool)

    /// ⏮ Rewind to the root ViewController of the current coordinator's NavigationController
    func popToRootViewController(animated: Bool)
}

/// Exposes what is allowed to be changed on the mainVC during setup in the `start(modalSetup:)` implementation
public protocol ViewControllerModalSetup: AnyObject {
    var definesPresentationContext: Bool { get set }
    var providesPresentationContextTransitionStyle: Bool { get set }
    var modalTransitionStyle: UIModalTransitionStyle { get set }
    var modalPresentationStyle: UIModalPresentationStyle { get set }
    var modalPresentationCapturesStatusBarAppearance: Bool { get set }
    // We might want to add some other stuff later, like transitioningDelegate and stuff, this might not be exhaustive yet
}

public protocol ViewControllerInitialSetup: AnyObject {
    func setInitialViewController(_ vc: UIViewController)
}

/**
 Struct used for gathering Coordinator's properties and setting their default value.
 */
public class CoordinatorComponents {
    let mainViewController = UINavigationController()
    let parentCoordinator: Coordinator?
    fileprivate var childCoordinators = [Coordinator]()

    public init(parentCoordinator: Coordinator? = nil) {
        self.parentCoordinator = parentCoordinator
    }
}

// MARK: Default Implementation

extension UINavigationController: ViewControllerInitialSetup, ViewControllerModalSetup {
    public func setInitialViewController(_ vc: UIViewController) {
        self.viewControllers = [vc]
    }
}

public extension Coordinator {
    func present(childCoordinator coordinator: Coordinator, animated: Bool = true, overrideModalSetup: ((ViewControllerModalSetup) -> Void)? = nil, completion: (() -> Void)? = nil) {
        self.components.childCoordinators.append(coordinator)
        coordinator.start(modalSetup: self.components.mainViewController)
        overrideModalSetup?(self.components.mainViewController)
        self.components.mainViewController.present(coordinator.components.mainViewController, animated: animated, completion: completion)
    }
    
    func dismissChildCoordinator(animated: Bool = true, completion: (() -> Void)? = nil) {
        self.components.mainViewController.dismiss(animated: animated, completion: completion)
        self.components.childCoordinators.removeAll()
    }
    
    func dismissToRoot<C: Coordinator>(coordinatorType: C.Type, completion: (() -> Void)? = nil) {
        self.dismissLoop(coordinatorType: coordinatorType, parentCoordinator: self.components.parentCoordinator)
    }
    
    fileprivate func dismissLoop<C: Coordinator>(coordinatorType: C.Type, parentCoordinator: Coordinator?, animated: Bool = true) {
        
        self.components.childCoordinators.removeAll()
        
        // 找到要回到的coordinator，從他的mainViewController dimiss
        if self is C {
            self.components.mainViewController.dismiss(animated: animated)
            
            return
        }
        
        if let parentCoordinator {
            // 隱藏前一個畫面(例：1 -> 2 -> 3, now is 3, 隱藏2, 但因為要回到1, 所以不能隱藏1)
            self.components.mainViewController.presentingViewController?.view.isHidden = String(describing: type(of: parentCoordinator)) != String(describing: coordinatorType)
            
            // 遞迴
            parentCoordinator.dismissLoop(coordinatorType: coordinatorType, parentCoordinator: parentCoordinator.components.parentCoordinator)
        } else {
            print("ParentCoordinator is nil")
        }
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.components.mainViewController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool) {
        self.components.mainViewController.popViewController(animated: animated)
    }

    func popToRootViewController(animated: Bool) {
        self.components.mainViewController.popToRootViewController(animated: animated)
    }
}

extension UITabBarController {
    public func configureTabs(using tabsCoordinators: [Coordinator]) {
        tabsCoordinators.forEach { $0.start(modalSetup: $0.components.mainViewController) }
        self.viewControllers = tabsCoordinators.map { $0.components.mainViewController }
    }
}
