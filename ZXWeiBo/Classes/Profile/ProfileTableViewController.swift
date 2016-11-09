//
//  ProfileTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class ProfileTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            visitorView.setupVisitorInfo(imageName: "visitordiscover_image_profile", title: "登录后看被人的评论，发给你的消息")
            return
        }
    }

   

}
