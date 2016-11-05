//
//  ZXPresentationController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/3.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class ZXPresentationController: UIPresentationController {

    lazy var coverBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    override func containerViewWillLayoutSubviews() {
        
        
        presentedView?.frame = CGRect(x: 100, y: 50, width: 200, height: 200)
        coverBtn.frame = UIScreen.main.bounds
        coverBtn.addTarget(self, action: #selector(ZXPresentationController.coverBtnClick), for: .touchUpInside)
        containerView?.insertSubview(coverBtn, at: 0)
        
    }
    
    
    func coverBtnClick()  {
       presentedViewController.dismiss(animated: true, completion: nil)
    }
    
     func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.popover
    }
}