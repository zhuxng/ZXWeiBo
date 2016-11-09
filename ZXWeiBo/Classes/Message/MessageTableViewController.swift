//
//  MessageTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView.setupVisitorInfo(imageName: "visitordiscover_image_message", title: "登录后，你的微薄、相册、个人资料会显示在这里")
            return
        }
    }

    

}
