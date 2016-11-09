//
//  AppDelegate.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/1.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //设置Window的根视图控制器
        window?.rootViewController = MainViewController()
        //设置Window可见
        window?.makeKeyAndVisible()
        //导航栏的tintColor
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        return true
    }
}

func ZXLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber:Int = #line)
{
//    print("\(fileName as NSString))\n\(methodName)\n lineNumber:\(lineNumber)\nmessage:\(message)")
    #if DEBUG

             print("在\((fileName as NSString).pathComponents.last!)控制器中在\(methodName)方法中的[第\(lineNumber)行]打印信息:\(message)")
        
       
    #endif
}

