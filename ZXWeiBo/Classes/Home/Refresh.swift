//
//  Refresh.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/12/3.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SnapKit


class ZXrefreshControl: UIRefreshControl {
    override init() {
        super.init()
        // 添加子控件
        addSubview(refreshView)
        
        //布局
        refreshView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 50))
            make.center.equalTo(self)
        }
        //监听frame值的改变
        addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
    }
    deinit {
        removeObserver(self, forKeyPath: "frame")
        
    }
    //实现方法
    var rotation = false
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if frame.origin.y == 0 || frame.origin.y == -64
        {
            // 过滤掉垃圾数据
            return
        }
        //判断是否触发下拉刷新事件
        if isRefreshing {
            //隐藏提示视图，并显示菊花
            refreshView.startLaoadingView()
            return
        }
        
        if frame.origin.y < -30 && !rotation {
            rotation = true
            refreshView.rotationArrow(flag: rotation)
            
        }else if frame.origin.y > -30 && rotation {
            rotation = false
            refreshView.rotationArrow(flag: rotation)
        }
        
    }
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.stopLoadingView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var refreshView: Refresh = Refresh.refreshView()
    
}
class Refresh: UIView {
    //菊花
    @IBOutlet weak var loadingView: UIImageView!
    //提示图
    @IBOutlet weak var tipView: UIView!

    //箭头
    @IBOutlet weak var arrowImageView: UIImageView!
  
    
    class func refreshView() -> Refresh {
        
        return Bundle.main.loadNibNamed("Refresh", owner: nil, options: nil)?.last as! Refresh
    }
    
    // MARK: - 外部控制方法
    
    func rotationArrow(flag: Bool) {
        UIView.animate(withDuration: 1.0) {
            
            var angle: CGFloat = flag ? -0.01 : 0.01
            angle += CGFloat(M_PI)
            
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: angle)
        }
    }
    
    func startLaoadingView() {
        
        tipView.isHidden = true
        //如果有动画了就不在继续添加动画   通过Forkey去取动画
        
        if let _ = loadingView.layer.animation(forKey: "zhuxing") {
            return
        }
        
        //创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
       
        //设置动画属性
        animation.toValue = 2 * M_PI// 旋转360度
        animation.duration = 2.0
        animation.repeatCount = MAXFLOAT// 循环转
        //将动画添加到图层上
        loadingView.layer.add(animation, forKey: "zhuxing")
    }
    /// 隐藏
    func stopLoadingView() {
        
        tipView.isHidden = false
        
        loadingView.layer.removeAllAnimations()
    }

}
