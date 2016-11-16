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
    
    
    
    //MARK: - 懒加载二维码扫描
    //输入对象
    private  var input: AVCaptureDeviceInput? = {
        let divice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: divice)
    }()
    //MARK: -会话
    var session = AVCaptureSession()
    //MARK: -输出对象
    lazy var output: AVCaptureMetadataOutput = {
       let out = AVCaptureMetadataOutput()
        // 输出对象感兴趣的范围  默认值（0，0，1，1）  传入的是比例
        let viewRect = self.view.frame
        let customRect = self.customContainerView.frame
        let x = customRect.origin.y / viewRect.height
        let y = customRect.origin.x / viewRect.width
        let h = customRect.width / viewRect.width
        let w = customRect.height / viewRect.height
        out.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        return out
    }()
    
    //MARK: -预览图层
    var preViewLayer = AVCaptureVideoPreviewLayer()
    //MARK: -专门用于描边的图层
    var containerLayer: CALayer = CALayer()
    
    @IBOutlet weak var customContainerView: UIView!
    
    //MARK: -结果文本
    @IBOutlet weak var customLabel: UILabel!

    @IBOutlet weak var scanLineView: UIImageView!
    //冲击波约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //底部工具条
    @IBOutlet weak var customTabBar: UITabBar!
   
    @IBOutlet weak var containerHeightCOns: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: - 1、选中第一个tabBarItem
        customTabBar.selectedItem  = customTabBar.items?.first
        //MARK: - 2、设置tabbar的代理
        customTabBar.delegate = self
        //3、开始扫描
        scanQRcode()
        
    }
    
    //MARK: - 二维码扫描
    private func scanQRcode() {
        
        //1、判断输入能否添加到会话中
        if !session.canAddInput(input) {
            return
        }
        //2、判断输出能否添加到会话中
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
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        //7、开始扫描
        session.startRunning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
   
        scanLineAnimation()
       
    }
    //MARK: - 扫面动画
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

    //MARK: - 打开相册
    @IBAction func photoBtn(_ sender: Any) {

        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true, completion: nil)
        
    
    
    }
   
  
}

//MARK: - 必须实现这两个代理UINavigationControllerDelegate,UIImagePickerControllerDelegate
extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1、从字典中拿到照片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        //2、选中二维码读取数据
        //2.1 创建一个探测器CIDetectorTypeQRCode《二维码》/CIDetectorTypeFace<人脸>/CIDetectorTypeText《文字》/CIDetectorTypeRectangle<矩形>
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        //2.2 探测数据
        guard let ciimage = CIImage(image: image) else {
            return
        }
        let results = detector?.features(in: ciimage)
        
        //2.3 取出探测到的数据
        for result in results! {
        ZXLog(message: (result as! CIQRCodeFeature).messageString)
            
        }
        
        //实现该方法后，系统不会自动关闭
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
}
//MARK: - 遵循AVCaptureMetadataOutputObjectsDelegate协议
extension QRCodeViewController :AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!){
       
        customLabel.text = metadataObjects.last.debugDescription
        clearLayers()
        //MARK: - 拿到corners  4个点
        guard let Metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        guard let objc = preViewLayer.transformedMetadataObject(for: Metadata) else {
            return
        }
        //MARK: - 描边
        drawLines(objc: (objc as! AVMetadataMachineReadableCodeObject))
    }
    //MARK: - 绘制描边
    func drawLines(objc: AVMetadataMachineReadableCodeObject) {
        
        //MARK: - 输出结果的安全校验
        guard let array = objc.corners else {
            return
        }
        
        
        let layer = CAShapeLayer()
        layer.lineWidth = 5
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        //MARK: - 绘制矩形区域
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        //MARK: - 通过字典创建Point的方法
        
        point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
        index += 1
        
        path.move(to: point)
        while index < array.count {
            point = CGPoint(dictionaryRepresentation: array[index] as! CFDictionary)!
            index += 1
            path.addLine(to: point)
        }
        path.close()
        layer.path = path.cgPath
        
        containerLayer.addSublayer(layer)
        
    }
    //MARK: - 清空描边
    private func clearLayers() {
        guard let subLayers = containerLayer.sublayers else {
            return
        }
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}


//MARK: - 实现tabbar的代理
extension QRCodeViewController :UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        containerHeightCOns.constant = (item.tag == 200) ? containerHeightCOns.constant : containerHeightCOns.constant / 2.0
        scanLineView.layer.removeAllAnimations()
        //这里注意不要使用scanLineView.layer.removeFromSuperlayer,因为程序要奔溃
        scanLineAnimation()
        
    
    }
}
