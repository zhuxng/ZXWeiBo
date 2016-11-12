//
//  OAuthViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/10.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController {
    @IBOutlet weak var customWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=1334968497&redirect_uri=http://www.520it.com"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(url: url as! URL)
        customWebView.delegate = self
        customWebView.loadRequest(request as URLRequest)

    }


}

extension OAuthViewController: UIWebViewDelegate {
    //该方法每次请求都会调用。
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        ZXLog(message: request)
        
        //http://www.520it.com/?code=f735d03aabd55e7ae692a2bba5458fca
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix("http://www.520it.com/") {
            ZXLog(message: "不是授权回调页")
            return true
        }
         ZXLog(message: "是授权回调页")
        //2、判断授权回调地址中是否包含code=
        //URL的query属性是专门获取URL中的参数
        
        let key = "code="
        if urlStr.contains(key) {
            ZXLog(message: "授权成功")
            let code = request.url?.query?.substring(from: key.endIndex)

            loadAccessToken(codeStr: code)
            return false
        }
        ZXLog(message: "授权失败")
        return false
    }
    func loadAccessToken(codeStr: String?) {
        guard let code = codeStr else {
            return
        }
        //1、准备请求路径：
        let path = "oauth2/access_token"
        //2、准备请求的参数
        let parameters = ["client_id":"1334968497","client_secret":"b198be1b669dcdcf5e2a1c7203686e6e","grant_type":"authorization_code","code":code,"redirect_uri":"http://www.520it.com"]
        
        //3、发送pust请求
        
        NetworkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, dict: Any?) in
            
            //授权成功
            let account = UserAccount(dict: dict as! [String : AnyObject])
            ZXLog(message: account.saveAccount())
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
        })
    }
}
