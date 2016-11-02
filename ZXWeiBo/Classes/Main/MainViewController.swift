//
//  MainViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = UIColor.orange
        self.addChildViewControllers()
    
        
    }
    func addChildViewControllers()
    {

        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
        
    }
    func addChildViewController(_ childController: UIViewController, title: String, imageName: String)
    {

         /*
         childController.title = title该句代码相当于childController.navigationItem.title = title childController.tabBarItem.title = title
         */
        
        childController.title = title
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
   //包装导航条
        let nav = UINavigationController(rootViewController: childController)
        
        self.addChildViewController(nav)
        
        
    }
}
