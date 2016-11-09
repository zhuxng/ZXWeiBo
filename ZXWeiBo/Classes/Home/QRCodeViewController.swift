//
//  QRCodeViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/9.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {
    
    
    
    // MARK: - 懒加载二维码扫描
    //输入对象
    private  var input: AVCaptureDeviceInput? = {
        let divice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: divice)
    }()
    //回话
    var session = AVCaptureSession()
    //输出对象
    var output = AVCaptureMetadataOutput()
    
    //预览图层
    var preViewLayer = AVCaptureVideoPreviewLayer()
    //结果文本
    @IBOutlet weak var customLabel: UILabel!

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
        //3、开始扫描
        scanQRcode()
        
    }
    
    
    private func scanQRcode() {
        
        //1、判断输入能否添加到回话中
        if !session.canAddInput(input) {
            return
        }
        //2、判断输出能否添加到回话中
        if !session.canAddOutput(output) {
            return
        }
        //3、添加输入输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        //4、设置输出能解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        //5、设置监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //6、添加预览图层
        
        preViewLayer = AVCaptureVideoPreviewLayer(session: session)
        preViewLayer.frame = view.bounds
        view.layer.insertSublayer(preViewLayer, at: 0)
        //7、开始扫描
        session.startRunning()
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
   
  
}

// MARK: - 遵循协议
extension QRCodeViewController :AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
        ZXLog(message: metadataObjects.last)
        
        
        customLabel.text = metadataObjects.last.debugDescription
    }
}

extension QRCodeViewController :UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        containerHeightCOns.constant = (item.tag == 200) ? containerHeightCOns.constant : containerHeightCOns.constant / 2.0
        scanLineView.layer.removeAllAnimations()
        //这里注意不要使用scanLineView.layer.removeFromSuperlayer,因为程序要奔溃
        scanLineAnimation()
        
    
    }
}
