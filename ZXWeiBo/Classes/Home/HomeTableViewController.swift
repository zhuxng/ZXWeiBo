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
    func setupNav(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",target: self, action: #selector(HomeTableViewController.rigthBtnClick))
        
        
        let titleBtn = TitleButton()
        titleBtn.setTitle("朱星   ", for: .normal)
        titleBtn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    
        // 再次回到HomeTableViewController动画不消失
//    override func viewDidAppear(_ animated: Bool) {
//        ZXLog(message: "2")
//        visitorView.startAnimation()
//        
//    }
    func titleBtnClick(btn:UIButton)  {
        btn.isSelected = !btn.isSelected
    }
    
    func leftBtnClick(btn:UIButton) {
        ZXLog(message: 1)
    }
    func rigthBtnClick(btn:UIButton) {
        ZXLog(message: 2)
    }
}
