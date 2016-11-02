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
     
    }

//    override func viewDidAppear(_ animated: Bool) {
//        ZXLog(message: "2")
//        visitorView.startAnimation()
//        
//    }
}
