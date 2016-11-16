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
        self.addChildViewControllers()  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.addSubview(composeButton)
        //设置composeButton在tabBar上的frame
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    //MARK: - 内部控制
    func addChildViewControllers()
    {
        // 1.根据JSON文件创建控制器
        // 1.1读取JSON数据
        guard let filePath =  Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else
        {
           
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else
        {
            return
        }
        
        // 1.2将JSON数据转换为对象(数组字典)
        do
        {
            let dic = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
            // 1.3遍历数组字典取出每一个字典
            for dict in dic
            {
                // 1.4根据遍历到的字典创建控制器
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName!, title: title!, imageName: imageName!)
            }
        }catch
        {
            // 只要try对应的方法发生了异常, 就会执行catch{}中的代码
            addChildViewController("HomeTableViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("MessageTableViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("NullViewController", title: "", imageName: "")
            addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }
    func addChildViewController(_ childControllerName: String!, title: String, imageName: String)
    {
        // 1.动态获取命名空间   这里和获取版本号类似
        guard let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else
        {
            return
        }
        // 2.根据字符串获取Class
        var cls: AnyClass? = nil
        if let vcName: String? = childControllerName
        {
            cls = NSClassFromString(name + "." + vcName!)
        }
        
        // 3.根据Class创建对象
        // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
        guard let typeCls = cls as? UITableViewController.Type else
        {
            return
        }
        // 通过Class创建对象
        let childController = typeCls.init()
        
        /*
         childController.title = title该句代码相当于下面两句childController.navigationItem.title = title childController.tabBarItem.title = title
         */
    
        childController.title = title
        
        childController.tabBarItem.image = UIImage(named: imageName)
        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        //包装导航条
        let nav = UINavigationController(rootViewController: childController)
        self.addChildViewController(nav)
   
    }
    
    //MARK: - 懒加载
    lazy var composeButton: UIButton = {
        () -> UIButton in
      let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImage: "tabbar_compose_button")
        btn.addTarget(self, action: #selector(MainViewController.composeButonClick), for: .touchUpInside)
        return btn
    }()
    
    func composeButonClick(btn: UIButton){
        
    }
    
    
}

