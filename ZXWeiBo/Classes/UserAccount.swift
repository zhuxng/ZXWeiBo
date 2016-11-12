//
//  UserAccount.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/12.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    
    var access_token = ""
    var expries_in: Int = 0
    var uid = ""
    //MARK: - 生命周期
    init(dict: [String: AnyObject]) {
        super.init()
        //如果想要在初始化方法中使用KVC必须先调用super.init（）初始化对象
        self.setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String{
        return "abc"
    }
    //MARK: - 外部控制方法
    func saveAccount() -> Bool {
        //1、获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2、生成缓存文档
        let filePath = (path as NSString).appendingPathComponent("userAcount.plist")
        ZXLog(message: filePath)
        //3、归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
    }
    //MARK: - 定义属性保存授权模型 ——>保证加载一次！
    static var account: UserAccount?
    //MARK: - 解归档
    class func loadUserAccount() -> UserAccount? {
        if UserAccount.account != nil {
            return UserAccount.account
        }
        ZXLog(message: "还没有加载过xxxxxxx")
        //1、获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2、生成缓存文档
        let filePath = (path as NSString).appendingPathComponent("userAcount.plist")
        //3、解归档对象
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount else {
            ZXLog(message: "还没有授权过xxxxxxx")
            return UserAccount.account
        }
        UserAccount.account = account
        return UserAccount.account
    }
    //判断是否登录过
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
     }
    
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expries_in, forKey: "expries_in")
        aCoder.encode(uid, forKey: "uid")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as! String
        self.expries_in = aDecoder.decodeInteger(forKey: "expries_in")
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String
        
    }

}

