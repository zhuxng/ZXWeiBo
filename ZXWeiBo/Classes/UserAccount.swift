//
//  UserAccount.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/12.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding{
    //用户信息
    var screen_name: String?
    var avatar_large: String?
    
    //令牌
    var access_token: String?
  
    //真正过期时间
    var expries_Date: NSDate?
    //生成过期时间
    //授权开始，过多少秒后过期时间
    var expires_in: Int = 0
        {
        didSet{
            //由具体的秒数转换为真正过期时间。
            expries_Date = NSDate(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    var uid: String?
    //MARK: - 生命周期
    init(dict: [String: AnyObject]) {
        super.init()
        //如果想要在初始化方法中使用KVC必须先调用super.init（）初始化对象
        self.setValuesForKeys(dict)
    }
    // 防奔溃。返回数据与模型不匹配。
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String{
        //将模型转换成字典
        let property = ["access_token","expires_in","uid","expries_Date"]
        // 将字典转换成字符串
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
    
    //MARK: - 定义属性保存授权模型 ——>保证加载一次！
    static var account: UserAccount?
    static let filePath: String = ("userAcount.plist").cachesDir()
    //MARK: - 外部控制方法
    //MARK: - 归档方法
    func saveAccount() -> Bool {
        //3、归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    //MARK: - 解归档
    class func loadUserAccount() -> UserAccount? {
        if UserAccount.account != nil {
            return UserAccount.account
        }
        //3、解归档对象，首先要拿到filePath这个路径
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else {
            return UserAccount.account
        }
        //3、校验是否过期
        
//        guard let date = account.expries_Date  else {
//            return nil
//        }
//        if date.compare(Date()) == ComparisonResult.orderedAscending{
//            return nil
//        }
// 
        //这里的逗号（，）原本是where的判断
        //compare <表示两个时间段的对比>!=后面表示升序
        guard let date = account.expries_Date, date.compare(Date()) != ComparisonResult.orderedAscending else {
            return nil
        }
        UserAccount.account = account
        return UserAccount.account
    }
    //判断是否登录过
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
     }
    /// 获取用户信息
    func loadUserInfo(finished: @escaping (_ account: UserAccount?, _ error: Error?)->()) {
        //断言
     assert(access_token != nil , "使用该方法必须先授权")
        let path = "2/users/show.json"
        let parameters = ["access_token":access_token,"uid":uid]
        NetworkTools.shareInstance.get(path, parameters: parameters, progress: nil, success: { (task, objct) in
            let dict = objct as! [String: Any]
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            //2、保存授权信息
            finished(self, nil)
            
        }, failure: { (task, error) in
            ZXLog(message: error)
        })
        
    }
    //MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expries_Date, forKey: "expries_Date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")

        
    }
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in")
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expries_Date = aDecoder.decodeObject(forKey: "expries_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }


}

