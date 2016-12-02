//  AppDelegate.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/1.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import Rswift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 一般情况下设置全局性的属性, 最好放在AppDelegate中设置, 这样可以保证后续所有的操作都是设置之后的操作
        // 1.设置外观
        //导航栏的tintColor
        UINavigationBar.appearance().tintColor = UIColor.orange
        //TabBar栏的tintColor
        UITabBar.appearance().tintColor = UIColor.orange

        
         // 2.注册通知监听
        NotificationCenter.default.addObserver(self, selector:
            #selector(AppDelegate.changeRootViewController), name: NSNotification.Name(rawValue: ZXSwitchRootViewController), object: nil)
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //设置Window的根视图控制器
        window?.rootViewController = defaultViewController()
        //设置Window可见
        window?.makeKeyAndVisible()
//        ZXLog(message: UserAccount.loadUserAccount()?.access_token)
        return true
        
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
}
 extension AppDelegate {
    //
    func defaultViewController() -> UIViewController {
        // 1.判断是否登录
        if UserAccount.isLogin() {
            //2、判断是否有新版
            if isNewVersion() {
                
                return R.storyboard.newFeatrue().instantiateInitialViewController()!
            }else {
                let sb = UIStoryboard(name: "Welcome", bundle: nil)
                return sb.instantiateInitialViewController()!
            }
        }
            // 没有登录
        else {
            return MainViewController()
        }
    }
    
    /// 切换根控制器
    func changeRootViewController(notice: Notification) {
        if notice.object as! Bool
        {
            window?.rootViewController = MainViewController()
        }else
        {
            let sb = UIStoryboard(name: "Welcome", bundle: nil)
            window?.rootViewController = sb.instantiateInitialViewController()!
        }
    }
    
    func isNewVersion() -> Bool{
        
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        let defaults = UserDefaults.standard
        
        let sanboxVersion = defaults.object(forKey: "CFBundleShortVersionString") as? String ?? "0.0"
        //降序
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending {
            defaults.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        return false
    }
 }
func ZXLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber:Int = #line)
{
    #if DEBUG

             print("在\((fileName as NSString).pathComponents.last!)控制器中在\(methodName)方法中的[第\(lineNumber)行]打印信息:\(message)")
        
       
    #endif
}

