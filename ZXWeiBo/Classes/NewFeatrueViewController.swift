//
//  NewFeatrueViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/15.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SnapKit

class NewFeatrueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
}

extension NewFeatrueViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewFeatrueCell", for: indexPath) as! ZXNewFeatrueCell
        cell.index = indexPath.item + 1
        
        return cell
    }
}


extension NewFeatrueViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //注意的是这里的Cell是上一个界面的cell
        //手动获取当前显示的Cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last!
        //根据indexPath获取当前对应的显示的Cell
        let currentCell = collectionView.cellForItem(at: index) as!  ZXNewFeatrueCell
        if index.item == 3 {
            //动画
            currentCell.startAnination()
        }
    }
}

class ZXNewFeatrueCell: UICollectionViewCell {
    var index = 1
        {
        didSet{
            let name = "new_feature_\(index)"
            iconImage.image = UIImage(named: name)
            startBtn.isHidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    //MARK: - 外部控制 - 开始动画
    func startAnination() {
        startBtn.isHidden = false
        /*
         usingSpringWithDamping 振幅
         initialSpringVelocity  加速度
         */
        startBtn.transform = CGAffineTransform(scaleX: 0, y: 0)
        startBtn.isUserInteractionEnabled = false
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(rawValue: 0), animations: {
            //取消所有的变形CGAffineTransform.identity
            self.startBtn.transform = CGAffineTransform.identity
        }, completion: { (_) in
            self.startBtn.isUserInteractionEnabled = true
        })
    }
    
    //MARK: - 内部控制
    func setupUI() {
        //添加子控件
        contentView.addSubview(iconImage)
        contentView.addSubview(startBtn)
        //snapkit 约束
        iconImage.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        startBtn.snp.makeConstraints { (make) in
            //一个Button最少要两个约束
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(-160)
        }
    }
    func startBtnClicked() {
        
    }
    private lazy var iconImage = UIImageView()
    private lazy var startBtn: UIButton = {
        let btn = UIButton(imageName: "", backgroundImage: "new_feature_button")
        btn.addTarget(self, action: #selector(ZXNewFeatrueCell.startBtnClicked), for: .touchUpInside)
        return btn
    }()
}

//MARK: - 自定义约束
class ZXNewFeatrueLayout: UICollectionViewFlowLayout {
   
    override func prepare() {
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
    
}
