//
//  ZXPresentationManager.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/9.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

// MARK: - 点击title弹出界面的方法  交给一个类来管理
class ZXPresentationManager: NSObject, UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning {
    
        private var isPresent = false
        //MARK: - UIViewControllerTransitioningDelegate
        //返回一个专场的对象
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return ZXPresentationController(presentedViewController: presented, presenting: presenting)
    }
        //返回一个如何出现的对象  展现时调用
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        //发一个通知，告诉调用者状态发生了改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZXPresentationManagerDIdPresented), object: nil)
            
        return self
    }
    //返回一个如何专场的对象的消失   消失时调用
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        //发一个通知，告诉调用者状态发生了改变
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZXPresentationManagerDIddismissed), object: nil)

        return self
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    //只要实现这个方法后就不会加载默认的动画了！transitionContext这太重要了
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            willPresentationController(using: transitionContext)
        }
        else{
        willdismissedViewController(using: transitionContext)
        }
    }
    //MARK: - 展现
    private func willPresentationController(using transitionContext: UIViewControllerContextTransitioning) {
        //获取要弹出的视图View
        let toView = transitionContext.view(forKey:
            UITransitionContextViewKey.to)
        transitionContext.containerView.addSubview(toView!)
        
        toView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        //设置锚点 anchorPoint
        toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView?.transform = CGAffineTransform.identity
        }) { (_) in
            //自定义专场后，一定要写这句话。
            transitionContext.completeTransition(true)
        }
    }
     //MARK: - 消失
    private func willdismissedViewController (using transitionContext: UIViewControllerContextTransitioning) {
        //1、拿到要消失的视图
        let fromView = transitionContext.view(forKey:
            UITransitionContextViewKey.from)
        //  2、添加动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.001)
        }) { (_) in
            transitionContext.completeTransition(true)
        }

    }
}
