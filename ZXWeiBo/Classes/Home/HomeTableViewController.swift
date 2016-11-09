//
//  HomeTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {
    
    var isPresent = false
    private lazy var animatorManager = ZXPresentationManager()
    private lazy var titleBtn: TitleButton = {
        let btn = TitleButton()
        btn.setTitle("朱星   ", for: .normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isLogin {
            visitorView.setupVisitorInfo(imageName: nil, title: "关注一些人。回这里看有什么惊喜")
            return
        }
        setupNav()
        
        //3注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChanged), name: NSNotification.Name(rawValue: ZXPresentationManagerDIdPresented), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChanged), name: NSNotification.Name(rawValue: ZXPresentationManagerDIddismissed), object: nil)
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func titleChanged() {
        titleBtn.isSelected = !titleBtn.isSelected
    }
    // MARK: - 内部控制
    func setupNav(){
        //MARK: - 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",target: self, action: #selector(HomeTableViewController.rigthBtnClick))
        
        //MARK: - 创建标题按钮
        navigationItem.titleView = titleBtn
    }
    @objc private func titleBtnClick(btn:UIButton)  {
        //MARK: - 通过UIStoryboard创建一个UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //MARK: - 以模态方式弹出UIViewController《从下忘上弹出》
        menuView.transitioningDelegate = animatorManager
        menuView.modalPresentationStyle = .custom
        present(menuView, animated: true)
    }
    
    @objc private func leftBtnClick(btn:UIButton) {
        ZXLog(message: 1)
    }
    @objc private func rigthBtnClick(btn:UIButton) {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        guard let QRVC = sb.instantiateInitialViewController() else {
            return
        }
        present(QRVC, animated: true, completion: nil)
        
    }
    
    
}

