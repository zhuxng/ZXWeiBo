//
//  User.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/17.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class User: NSObject {
    
    ///字符串型的用户UID
    var idstr: String?
    ///用户昵称
    var screen_name: String?
    ///用户头像地址
    var profile_image_url: String?
    ///用户认证类型
    var verified_type = 0
    ///会员等级  取值范围1~6
    var mbrank: Int = -1
    
    

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
        let property = ["idstr","screen_name","profile_image_url","verified_type","mbrank"]
        
        // 将字典转换成字符串
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
