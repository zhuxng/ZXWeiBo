//
//  ZXPresentationController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/3.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class ZXPresentationController: UIPresentationController {

    private lazy var coverBtn: UIButton = {
        //MARK: - 添加蒙版
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        btn.addTarget(self, action: #selector(ZXPresentationController.coverBtnClick), for: .touchUpInside)
//        btn.backgroundColor = UIColor.gray
        return btn
    }()
    //MARK: - 布局专场动画弹出控件
    override func containerViewWillLayoutSubviews() {
        //containerView 容器视图
        //presentedView 拿到弹出的视图
        presentedView?.frame = CGRect(x: 100, y: 50, width: 200, height: 200)
        containerView?.insertSubview(coverBtn, at: 0)
        
    }
    //MARK: - 消失
    func coverBtnClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
}
