//
//  NetworkTools.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/12.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {

    //Swift推荐我们这样写一个单列： instance实列
    static let shareInstance: NetworkTools = {
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        let instance = NetworkTools(baseURL: baseURL as URL, sessionConfiguration: URLSessionConfiguration.default)
        instance.responseSerializer.acceptableContentTypes = NSSet(objects: "text/plain","application/json", "text/json", "text/javascript") as? Set<String>
        return instance
    }()
    //MARK: - 外部控制方法
    //finished: (array: [String: AnyObject]?, error: Error?)->()回调
    func loadStatuses(finished: @escaping (_ array: [[String: AnyObject]]?, _ error: Error?)->())  {
        assert(UserAccount.loadUserAccount()?.access_token != nil, "先授权再发送数据请求")
        //准备路径
        let path = "2/statuses/home_timeline.json"
        //2、准备参数
        let parameters = ["access_token":"2.00LQqZWBxR529B3f8390f72aNPJZ8D"]
        
        //3、发起请求
        get(path, parameters: parameters, progress: nil, success: { (task, objc) in
            //拿到objc数据
            //放回数据给调用者
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else {
                
                finished(nil, NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message":"没有获取数据"]))
                return
            }
            finished(arr, nil)
        
        }, failure: { (task, errer) in

            finished(nil, errer)
        })
        
    }
    
}
