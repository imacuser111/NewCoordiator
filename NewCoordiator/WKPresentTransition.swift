//
//  SKSTrinstain.swift
//  NewTalk
//
//  Created by user on 2020/10/29.
//

import Foundation
import UIKit

/// 自訂開啟傳遞動畫
struct WKPresentTransition {
    
    /// 右到左換頁動畫
    class RightToLeftAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        // 定義轉場動畫為0.8秒
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.8
        }
        
        // 具體的轉場動畫
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
           
            guard let toVC = transitionContext.viewController(forKey: .to),
                  let toView = toVC.view,
                  let fromVC = transitionContext.viewController(forKey: .from),
                  let fromView = fromVC.view
            else {
                
                transitionContext.completeTransition(false)
                return
            }
            
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            toView.frame.origin = CGPoint(x: toView.frame.width, y: 0)
            
            // 轉場動畫
            toView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            UIView.animate(withDuration: 0.4, animations: {
                toView.frame = fromView.frame
                fromView.frame = fromView.frame.offsetBy(dx: -(fromView.frame.width), dy: 0)
            }, completion: { finished in
                UIView.animate(withDuration: 0.4, animations: {
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    fromView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                }, completion: { finished in
                    // 通知完成轉場
                    transitionContext.completeTransition(true)
                })
            })
        }
    }
    
    /// 彈窗顯示動畫 (附有黑色遮罩)
    class DialogAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        /// 動畫類型
        private var style: TransitioningDialogAnimation
        
        /// 遮罩透明度
        private var maskAlpha: CGFloat
        
        /// 動畫間隔
        private var duration: TimeInterval
        
        
        init(style: TransitioningDialogAnimation, duration: TimeInterval, maskAlpha: CGFloat = 0.4) {
            
            self.style = style
            self.maskAlpha = maskAlpha
            self.duration = duration
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            self.duration
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
            guard let toVC = transitionContext.viewController(forKey: .to),
                  let toView = toVC.view
            else {
                
                transitionContext.completeTransition(false)
                return
            }
            
    
            // 設定最終位置
            toView.frame = transitionContext.finalFrame(for: toVC)
            toView.backgroundColor = .black.withAlphaComponent(0)
            
    
            // 生成快照
            guard let snapshotView = toView.snapshotView(afterScreenUpdates: true) else {
                transitionContext.completeTransition(false)
                return
            }
            
            // 設定背景遮罩 (頁面本身的背景遮罩會有破綻，故用假遮罩騙。)
            let backgroundMask = UIView(frame: toView.frame)
            backgroundMask.backgroundColor = .black.withAlphaComponent(maskAlpha)
            backgroundMask.alpha = 0
            
            // 設定快照
            snapshotView.frame = transitionContext.finalFrame(for: toVC)
            snapshotView.frame = self.style.offset(withFrame: toView.frame)
            snapshotView.alpha = 0.5
            
            // 隱藏原本最終圖片
            toView.alpha = 0
            
            // 添加至容器
            let containerView = transitionContext.containerView
            containerView.addSubview(toView)
            containerView.addSubview(backgroundMask)
            containerView.addSubview(snapshotView)
                    
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                
                snapshotView.frame = transitionContext.finalFrame(for: toVC)
                snapshotView.alpha = 1
                
                backgroundMask.alpha = 1
                
                }, completion: { [weak self] finished in
                
                    // 移除多餘圖層
                    snapshotView.removeFromSuperview()
                    backgroundMask.removeFromSuperview()
                    
                    // 顯示最終頁面
                    toView.backgroundColor = .black.withAlphaComponent(self?.maskAlpha ?? 0.4)
                    toView.alpha = 1
                    
                    // 完成
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}

/// 自訂關閉傳遞動畫
struct WKDismissPresentTransition {
    
    /// 左到右換頁動畫
    class LeftToRightAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        // 定義轉場動畫為0.8秒
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.8
        }
        
        // 具體的轉場動畫
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
            guard let toVC = transitionContext.viewController(forKey: .to),
                  let toView = toVC.view,
                  let fromVC = transitionContext.viewController(forKey: .from),
                  let fromView = fromVC.view
            else {
                
                transitionContext.completeTransition(false)
                return
            }
            
            let containerView = transitionContext.containerView
            containerView.addSubview(fromView)
            fromView.frame.origin = .zero
            
            // 轉場動畫
            toView.frame = CGRect(x: -(fromView.frame.width), y: 0, width: fromView.frame.width, height: fromView.frame.height)
            UIView.animate(withDuration: 0.4, animations: {
                toView.frame = fromView.frame
                fromView.frame = fromView.frame.offsetBy(dx: fromView.frame.width, dy: 0)
            }, completion: { finished in
                UIView.animate(withDuration: 0.4, animations: {
                    fromView.removeFromSuperview()
                    toView.frame = CGRect(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                }, completion: { finished in
                    // 通知完成轉場
                    toVC.view.layoutIfNeeded()
                    transitionContext.completeTransition(true)
                })
            })
        }
    }
    
    /// 彈窗顯示動畫 (附有黑色遮罩)
    class DialogAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
        
        /// 動畫類型
        private var style: TransitioningDialogAnimation
        
        /// 移除透明度
        private var fadeOutAlpha: CGFloat
        
        /// 動畫間隔
        private var duration: TimeInterval
        
        
        init(style: TransitioningDialogAnimation, duration: TimeInterval, fadeOutAlpha: CGFloat = 1) {
            
            self.style = style
            self.fadeOutAlpha = fadeOutAlpha
            self.duration = duration
        }
        
        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            self.duration
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            
            guard let fromVC = transitionContext.viewController(forKey: .from),
                  let fromView = fromVC.view,
                  let toVC = fromVC.presentingViewController,
                  let toView = toVC.view
            else {
                
                transitionContext.completeTransition(false)
                return
            }
            
            // 設定最終位置
            toView.frame = transitionContext.finalFrame(for: toVC)
            toView.alpha = 1
            
           
            // 快照前，調整背景色。
            fromView.backgroundColor = .clear
            
            // 生成快照
            guard let snapshotView = fromView.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(false)
                return
            }
            
            // 設定快照
            snapshotView.frame = fromView.frame
            snapshotView.alpha = 1
            
            // 添加至容器
            let containerView = transitionContext.containerView
            containerView.addSubview(snapshotView)
            
            // 移除本身
            fromView.removeFromSuperview()
            
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { [weak self] in
                
                snapshotView.frame = self?.style.offset(withFrame: fromView.frame) ?? fromView.frame
                snapshotView.alpha = self?.fadeOutAlpha ?? 1
                
                
                }, completion: { finished in
                
                    // 移除多餘圖層
                    snapshotView.removeFromSuperview()
                    
                    // 完成
                    transitionContext.completeTransition(true)
                }
            )
        }
    }
}


/// 背景有遮罩
enum TransitioningDialogAnimation {
    
    /// 放大
    case scale
    
    /// 方向
    case top, right, left, bottom
    
    /// 需要進場的位移
    func offset(withFrame viewFrame: CGRect) -> CGRect {
        
        let h = UIScreen.main.bounds.size.height
        let w = UIScreen.main.bounds.size.width
        
        switch self {
        case .top:
            return viewFrame.offsetBy(dx: 0, dy: -h)
        case .bottom:
            return viewFrame.offsetBy(dx: 0, dy: h)
        case .left:
            return viewFrame.offsetBy(dx: -w, dy: 0)
        case .right:
            return viewFrame.offsetBy(dx: w, dy: 0)
        case .scale:
            return viewFrame.insetBy(dx: viewFrame.size.width * 0.1, dy: viewFrame.size.height * 0.1)
        }
    }
}
