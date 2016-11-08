//
//  VistorView.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/3.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class VistorView: UIView {
    /*
     通知 : 层级结构较深
     代理 : 父子 , 方法较多时候使用
     block: 父子, 方法较少时使用(一般情况一个方法)
     */
   
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var rotationView: UIImageView!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    //设置访客视图的数据
    //imageName 设置为可选类型
    func setupVisitorInfo(imageName: String?, title: String) {
        //设置标题
     
        textLabel.text = title
        guard imageName != nil else {
            
            startAnimation()
            
            return
        }
        rotationView.isHidden = true
        iconView.image = UIImage(named: (imageName)!)

    }
    
    // MARK: - 通过storyboad加载
    
    //相当于OC中的 +“对象方法”
    class func visitorView() ->VistorView {
        return Bundle.main.loadNibNamed("VistorView", owner: nil, options: nil)?.last as! VistorView
        
    }
    
    func startAnimation() {
        //创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        animation.toValue = 2 * M_PI// 旋转360度
        animation.duration = 5.0
        animation.repeatCount = MAXFLOAT// 循环转
        
        animation.isRemovedOnCompletion = false
        //将动画添加到图层上
        rotationView.layer.add(animation, forKey: nil)
    }
    
    
}
