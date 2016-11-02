//
//  AppDelegate.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/1.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import QorumLogs
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.\
//        QorumLogs.enabled = true
//        QorumLogs.test()
       
//        print(#file)
//        print(#function)
//        print(#line)
        ZXLog(message: "zhuxing")
        return true
    }
}

func ZXLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber:Int = #line)
{
//    print("\(fileName as NSString))\n\(methodName)\n lineNumber:\(lineNumber)\nmessage:\(message)")
    #if DEBUG
        print("在\(methodName)方法中的[第\(lineNumber)行]打印信息:\(message)")
    #endif
}

