//
//  BaseViewController.swift
//  NewCoordiator
//
//  Created by Cheng-Hong on 2024/7/26.
//

import UIKit

protocol BaseViewControllerNavigation: AnyObject {
    // Add here functions to navigate away from this screen, to ask the Coordinator to show another screen
    func backButtonTrigger()
}

extension BaseViewController {
    /// 返回按鈕樣式
    enum BackButtonStyle {
        case back
        case close
    }
}

class BaseViewController: UIViewController {
    // back button
    let backBtn = UIButton(type: .custom)
    
    weak var backDelegate: BaseViewControllerNavigation?
    
    deinit {
        print("deinit: \(self)")
    }
    
    func addBackPresentRootViewController(style: BaseViewController.BackButtonStyle = .back) {
        
        // 安裝返回按鈕
        backBtn.setupBackButton(style)
        
        backBtn.addTarget(
            self,
            action: #selector(onBackButtonTap),
            for: .touchUpInside
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
    }
    
    @objc private func onBackButtonTap(_ sender: UIButton) {
        backBtn.isEnabled = false
        backDelegate?.backButtonTrigger()
    }
}

extension UIButton {
    
    func setupBackButton(_ style: BaseViewController.BackButtonStyle) {
        switch style {
        case .back:
            setImage(.actions, for: .normal)
        case .close:
            setImage(.add, for: .normal)
        }
    }
}
