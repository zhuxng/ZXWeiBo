//
//  DiscoverTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView.setupVisitorInfo(imageName: "visitordiscover_image_profile", title: "登陆后，最新最热的微薄尽在掌握中......")
            return
        }
    }
}
