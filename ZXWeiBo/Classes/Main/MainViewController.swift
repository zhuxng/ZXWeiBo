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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.addSubview(composeButton)
        let rect = composeButton.frame
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    //MARK: - 内部控制器
    func addChildViewControllers()
    {
        
        // 1.根据JSON文件创建控制器
        // 1.1读取JSON数据
        guard let filePath =  Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else
        {
            ZXLog(message: "JSON文件不存在")
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else
        {
            ZXLog(message: "加载二进制数据失败")
            return
        }
        
        // 1.2将JSON数据转换为对象(数组字典)
        do
        {
            //            let objc = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
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
        // 1.动态获取命名空间
        guard let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else
        {
            ZXLog(message: "获取命名空间失败")
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
            ZXLog(message: "cls不能当做UITableViewController")
            return
        }
        // 通过Class创建对象
        let childController = typeCls.init()
        
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
    
    //MARK: - 懒加载
    lazy var composeButton: UIButton = {
        () -> UIButton
        in
        //1、创建按钮
        /*
        let btn = UIButton()
        //2、设置当前图片
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: .normal)
        //3、设置背景图片
        btn.setImage(UIImage.init(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button_highlighted"), for: .highlighted)
          btn.sizeToFit()
        */
//        let btn = UIButton()
//        btn.createButton(imageName: "tabbar_compose_icon_add", backgroundImage: "tabbar_compose_button")
        
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImage: "tabbar_compose_button")
        btn.addTarget(self, action: #selector(MainViewController.composeButonClick), for: .touchUpInside)
        //4、设置frame
       
        return btn
    }()
    func composeButonClick(btn: UIButton){
        ZXLog(message: btn)
    }
    
    
}
//extension UIButton
//{
//      func createButton(imageName: String,backgroundImage: String) {
//       
//        setImage(UIImage.init(named: imageName), for: .normal)
//        setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
//        setBackgroundImage(UIImage.init(named: backgroundImage), for: .normal)
//        setBackgroundImage(UIImage.init(named: backgroundImage + "_highlighted"), for: .highlighted)
//        sizeToFit()
//    }
//    
//}
