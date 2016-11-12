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
        instance.responseSerializer.acceptableContentTypes = NSSet(object: "text/plain") as? Set<String>
        return instance
    }()
    
    
}
