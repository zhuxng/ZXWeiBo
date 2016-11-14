//
//  String + Extrnsion.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/13.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
extension String
{
    func cachesDir() -> String {
        //caches  缓存
        //1、获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2、生成缓存文档
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
        
    }
    func docDir() -> String {
        //document  文档
        //1、获取缓存目录路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2、生成缓存文档
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)

        return filePath
    }
    func tmpDir() -> String {
        //Temporary:临时
        //1、获取缓存目录路径
        let path = NSTemporaryDirectory()
        //2、生成缓存文档
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        return filePath
    }
    
    
}
