//
//  UIBarButtonItem + Extension.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/3.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    convenience init(imageName: String,target: AnyObject?, action: Selector){
        let btn = UIButton()
        
        btn.createButton(imageName: imageName)
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
        
    }
}
