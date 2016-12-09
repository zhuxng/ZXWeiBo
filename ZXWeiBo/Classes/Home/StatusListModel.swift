

//
//  StatusListModel.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/12/9.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class StatusListModel: UIView {
    
    
    var statuses: [StatusViewModel]?
    
    //MARK: - 数据加载
    func loadData(lastStatus: Bool, finished: @escaping (_ models: [StatusViewModel]?, _ error: Error?) -> ()) {
        
        var since_id = statuses?.first?.status.idstr ?? "0"
        var max_id = "0"
        
        if lastStatus {
            since_id = "0"
            max_id = statuses?.last?.status.idstr ?? "0"
        }
        // 发送网络请求
        NetworkTools.shareInstance.loadStatuses(since_id: since_id,max_id: max_id) { (array, error) in
            if error != nil {
                finished(nil, error)
                return
            }
            //2、将字典转换成模型数组
            var models = [StatusViewModel]()
            for dict in array! {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            //3、处理微博数据
            if since_id != "0" {
                
                self.statuses = models + self.statuses!
            }else if max_id != "0"  {
                self.statuses = self.statuses! + models
            }
            else {
                self.statuses = models
            }
            //4、缓存所有的配图
            self.cachesImages(viewModels: models, finished: finished)
        }
    }
    
    // MARK: - 图片缓存
    private func cachesImages(viewModels: [StatusViewModel], finished: @escaping (_ models: [StatusViewModel]?, _ error: Error?) -> ()) {
        let myQueue = DispatchQueue(label: "第一条线程")
        let group = DispatchGroup.init()
        for viewModel in viewModels {
            let picurls = viewModel.thumbnail_pic!
            for url in picurls {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: url as URL!, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    
                    group.leave()
                })
            }
        }
        group.notify(queue: myQueue) {
            finished(viewModels, nil)
        }
    }

    

}
