//
//  Status.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/17.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
class Status: NSObject {
    
    ///微博创建时间
    var created_at: String?
    ///字符串型的微博ID
    var idstr: String?
    ///微博信息内容
    var text: String?
    ///微博来源
    var source: String?
    
    ///用户信息
    var user: User?
   
    
    init(dict: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    /// 该方法会内部会调用setValuesForKeys(dict)
    override func setValue(_ value: Any?, forKey key: String) {
        //1、拦截user赋值操作
        if key == "user" {
            user = User(dict: value as! [String: AnyObject])
            return
        }
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let property = ["created_at","idstr","source","text"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
        
        
    }
}
