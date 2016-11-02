//
//  UIButton + Extension.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
extension UIButton
{
    convenience init(imageName: String,backgroundImage: String) {
        self.init()
        setImage(UIImage.init(named: imageName), for: .normal)
        setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage.init(named: backgroundImage), for: .normal)
        setBackgroundImage(UIImage.init(named: backgroundImage + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
}
