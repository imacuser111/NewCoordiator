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

class BaseCoordinator: NSObject, Coordinator, BaseViewControllerNavigation {
    let components: CoordinatorComponents
    
    deinit {
        print("deinit: \(self)")
    }
    
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
        self.dismissToRoot(coordinatorType: TutorialCoordinator.self)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension BaseCoordinator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = WKPresentTransition.RightToLeftAnimatedTransition()
        
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = WKDismissPresentTransition.LeftToRightAnimatedTransition()
        
        return transition
    }

}

class CustomPopToRootAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // 动画持续时间
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)

        let duration = transitionDuration(using: transitionContext)
        UIView.transition(with: containerView, duration: duration, options: .transitionCrossDissolve, animations: {
            fromView.alpha = 0
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}
