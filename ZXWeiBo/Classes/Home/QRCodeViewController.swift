//
//  QRCodeViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/9.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {

    @IBOutlet weak var scanLineView: UIImageView!
    //冲击波约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //底部工具条
    @IBOutlet weak var customTabBar: UITabBar!
   
    @IBOutlet weak var containerHeightCOns: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //选中第一个tabBarItem
        customTabBar.selectedItem  = customTabBar.items?.first
        customTabBar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
   
        scanLineAnimation()
       
    }
    func scanLineAnimation() {
        scanLineCons.constant = -containerHeightCOns.constant
        view.layoutIfNeeded()
        //执行扫描动画
        //在闭包中必须使用self，访问外界属性
        UIView.animate(withDuration: 1.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCOns.constant
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func photoBtn(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension QRCodeViewController :UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        containerHeightCOns.constant = (item.tag == 200) ? containerHeightCOns.constant : containerHeightCOns.constant / 2.0
        scanLineView.layer.removeAllAnimations()
        //这里注意不要使用scanLineView.layer.removeFromSuperlayer,因为程序要奔溃
        scanLineAnimation()
        
    
    }
}
