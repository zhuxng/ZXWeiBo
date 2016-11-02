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
//    func addChildViewControllers()
//    {
//
//        addChildViewController(HomeTableViewController(), title: "首页", imageName: "tabbar_home")
//        addChildViewController(MessageTableViewController(), title: "消息", imageName: "tabbar_message_center")
//        addChildViewController(DiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
//        addChildViewController(ProfileTableViewController(), title: "我的", imageName: "tabbar_profile")
//        
//    }
    
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
            /*
             Swift和OC不太一样, OC中一般情况如果发生错误会给传入的指针赋值, 而在Swift中使用的是异常处理机制
             1.以后但凡看大 throws的方法, 那么就必须进行 try处理, 而只要看到try, 就需要写上do catch
             2.do{}catch{}, 只有do中的代码发生了错误, 才会执行catch{}中的代码
             3. try  正常处理异常, 也就是通过do catch来处理
             try! 告诉系统一定不会有异常, 也就是说可以不通过 do catch来处理
             但是需要注意, 开发中不推荐这样写, 一旦发生异常程序就会崩溃
             如果没有异常那么会返回一个确定的值给我们
             
             try? 告诉系统可能有错也可能没错, 如果没有系统会自动将结果包装成一个可选类型给我们, 如果有错系统会返回nil, 如果使用try? 那么可以不通过do catch来处理
             */
            
            let objc = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
            
            // 1.3遍历数组字典取出每一个字典
            for dict in objc
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
            addChildViewController("DiscoverTableViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileTableViewController", title: "我", imageName: "tabbar_profile")
        }
    }
    
    
    
    func addChildViewController(_ childControllerName: String, title: String, imageName: String)
    {
        // 1.动态获取命名空间
        guard let name =  Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else
        {
            ZXLog(message: "获取命名空间失败")
            return
        }
        
        // 2.根据字符串获取Class
        var cls: AnyClass? = nil
        if let vcName: String = childControllerName
        {
            cls = NSClassFromString(name + "." + vcName)
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
}
