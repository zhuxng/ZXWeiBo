//
//  OAuthViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/10.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SVProgressHUD


class OAuthViewController: UIViewController {
    var isSave = false
    @IBOutlet weak var customWebView: UIWebView!
    
    @IBAction func coloseBtnClicked(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func autoBtnClicked(_ sender: Any) {
        
        
        let jsStr = "document.getElementById('userId').value = 'zx13890504900@sina.com';"
        
        let password = "document.getElementById('passwd').value = 'zhuxing891006';"
     
        customWebView.stringByEvaluatingJavaScript(from: password)
        
        customWebView.stringByEvaluatingJavaScript(from: jsStr)
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_redirect_uri)"
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(url: url as! URL)
        customWebView.delegate = self
        customWebView.loadRequest(request as URLRequest)
    }

}
extension OAuthViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.showInfo(withStatus: "拼命加载中...")
        SVProgressHUD.showProgress(100)
        SVProgressHUD.show()
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    //该方法每次请求都会调用。
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //ZXLog(message: request)
        //http://www.520it.com/?code=f735d03aabd55e7ae692a2bba5458fca
         //这里的urlStr = https://api.weibo.com/oauth2/authorize?client_id=1334968497&redirect_uri=http://www.520it.com
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix(WB_redirect_uri) {
            ZXLog(message: "不是授权回调页")
            return true
        }
        //2、判断授权回调地址中是否包含code=
        //URL的query属性是专门获取URL中的参数
        let key = "code="
        guard let str = request.url?.query else {
            //这里的str = "code=9654618e2a64997431413163b691a0f3"
            return false
        }
        if str.hasPrefix(key) {
            //query  查询
            let code = str.substring(from: key.endIndex)
            loadAccessToken(codeStr: code)
            return false
        }
        //ZXLog(message: "授权失败")
        return false
    }
    func loadAccessToken(codeStr: String?) {
        guard let code = codeStr else {
            return
        }
        //1、准备请求路径：
        let path = "oauth2/access_token"
        //2、准备请求的参数
        let parameters = ["client_id":WB_App_Key,"client_secret":WB_App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":WB_redirect_uri]
        //3、发送pust请求
        NetworkTools.shareInstance.post(path, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, dict: Any?) in
            //授权成功
            
            //字典转模型
            let account = UserAccount(dict: dict as! [String : AnyObject])
            account.loadUserInfo(finished: { (acount, error) in
               self.isSave = account.saveAccount()
                // 发出通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZXSwitchRootViewController), object: false)
//                self.dismiss(animated: true, completion: nil)
                
            })

        }, failure: { (task: URLSessionDataTask?, error: Error) in
            
            ZXLog(message: error)
        })
    }
}
