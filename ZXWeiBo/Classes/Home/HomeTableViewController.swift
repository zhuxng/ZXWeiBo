//
//  HomeTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        if !isLogin {
            visitorView.setupVisitorInfo(imageName: nil, title: "关注一些人。回这里看有什么惊喜")
            return
        }
        setupNav()

        
    }
        // MARK: - 再次回到HomeTableViewController动画不消失
//    override func viewDidAppear(_ animated: Bool) {
//        visitorView.startAnimation()
//        
//    }
    // MARK: - 内部控制
    func setupNav(){
        //MARK: - 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",target: self, action: #selector(HomeTableViewController.rigthBtnClick))
        
        //MARK: - 创建标题按钮
        let titleBtn = TitleButton()
        titleBtn.setTitle("朱星   ", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    @objc private func titleBtnClick(btn:UIButton)  {
        btn.isSelected = !btn.isSelected
        //MARK: - 通过UIStoryboard创建一个UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //MARK: - 以模态方式弹出UIViewController《从下忘上弹出》
        menuView.transitioningDelegate = self
        menuView.modalPresentationStyle = .custom
        present(menuView, animated: true)
    }
    
    @objc private func leftBtnClick(btn:UIButton) {
        ZXLog(message: 1)
    }
    @objc private func rigthBtnClick(btn:UIButton) {
        ZXLog(message: 2)
    }
     var isPresent = false
}

// MARK: - 点击title弹出界面的方法
extension HomeTableViewController: UIViewControllerTransitioningDelegate {
    //返回一个专场的对象
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return ZXPresentationController(presentedViewController: presented, presenting: presenting)
    }
    //返回一个如何专场的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    //返回一个如何专场的对象的消失
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}
extension HomeTableViewController : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 10
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //展现
        if isPresent {
            let toView = transitionContext.view(forKey:
                UITransitionContextViewKey.to)
            
            transitionContext.containerView.addSubview(toView!)
            
            toView?.transform = __CGAffineTransformMake(0, 0, 0, 0, 1.0, 0)
            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            UIView.animate(withDuration: 1.0, animations: {
                toView?.transform = CGAffineTransform.identity
            }) { (_) in
                transitionContext.completeTransition(true)
            }
            
        }
            //消失
        else{
            let fromView = transitionContext.view(forKey:
                UITransitionContextViewKey.from)
            
            UIView.animate(withDuration: 1.0, animations: {
                fromView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.001)
            }) { (_) in
                transitionContext.completeTransition(true)
            }
        }
    }
}
