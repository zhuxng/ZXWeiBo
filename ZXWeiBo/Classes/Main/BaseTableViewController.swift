//
//  BaseTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var isLogin = UserAccount.isLogin()
    var visitorView = VistorView()
    override func loadView() {
        isLogin ? super.loadView() : setUpVisitorView()
    }

    func setUpVisitorView() {
        
       visitorView = VistorView.visitorView()
        view = visitorView
        //去访问点击按钮属性
        visitorView.registerButton.addTarget(self, action: #selector(BaseTableViewController.registerBtnClick), for: .touchUpInside)
         visitorView.loginButton.addTarget(self, action: #selector(BaseTableViewController.loginBtnClick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(BaseTableViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(BaseTableViewController.loginBtnClick))
    }
  
    func registerBtnClick(btn: UIButton) {
        ZXLog(message: "")
    }
    func loginBtnClick(btn: UIButton) {
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let VC = sb.instantiateInitialViewController()
        present(VC!, animated: true, completion: nil)
        
    }
}

