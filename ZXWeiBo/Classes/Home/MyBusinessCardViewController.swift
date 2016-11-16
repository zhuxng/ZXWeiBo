//
//  MyBusinessCardViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/10.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class MyBusinessCardViewController: UIViewController {

    //二维码容器
    @IBOutlet weak var myImagaeView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setDefaults()
        filter?.setValue("朱星".data(using: String.Encoding.utf8, allowLossyConversion: true), forKey: "InputMessage")

        guard let ciimage = filter?.outputImage else {
            return
        }
        
//        myImagaeView.image = UIImage(ciImage: ciimage)
        myImagaeView.image = createNonInterpolatedUIImageFormCIImage(image: ciimage, size: 500)
        
    }
    
    /*
     高清二维码
     */
 private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
 
     let extent: CGRect = image.extent.integral
     let scale: CGFloat = min(size/extent.width, size/extent.height)
     
     // 1.创建bitmap;
     let width = extent.width * scale
     let height = extent.height * scale
     let cs = CGColorSpaceCreateDeviceGray()
     let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: 0)!
     
     let context = CIContext(options: nil)
     let bitmapImage: CGImage = context.createCGImage(image, from: extent)!
     
     bitmapRef.interpolationQuality = CGInterpolationQuality.none
     bitmapRef.scaleBy(x: scale, y: scale);

     bitmapRef.draw(bitmapImage, in: extent, byTiling: true)
//         CGContextDrawImage(bitmapRef, extent, bitmapImage);

// 2.保存bitmap到图片
     let scaledImage: CGImage = bitmapRef.makeImage()!
     
     return UIImage(cgImage: scaledImage)
     }
    
    
}
