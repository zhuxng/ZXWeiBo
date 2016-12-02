//
//  HomeTableViewCell.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/17.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SDWebImage

class HomeForWordTableViewCell: UITableViewCell {

    @IBOutlet weak var homeCollectionPicView: UICollectionView! {
        didSet{
            homeCollectionPicView.dataSource = self
        }
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    //容器高度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    // 容器宽度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    
    
    @IBOutlet weak var footerView: UIView!
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!

    @IBOutlet weak var forwordText: UILabel!
    
    /// 模型数据
    var viewModel: StatusViewModel?
        {
        didSet{
            // 1.设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL as URL!)
            iconImageView.layer.cornerRadius = 25
            
            // 2.设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            // 3.设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
            // 4.设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let image = viewModel?.mbrankImage {
                vipImageView.image = image
                nameLabel.textColor = UIColor.orange
            }
            // 5.设置时间
            timeLabel.text = viewModel?.created_Time
            // 6.设置来源
            sourceLabel.text = viewModel?.source_Text
            // 7.设置正文
            contentLabel.text = viewModel?.status.text
            //8、
            homeCollectionPicView.reloadData()
            let (itemSize, clvSize) = calculateSize()
            if itemSize != CGSize.zero {
                flowLayout.itemSize = itemSize
            }
            //9、
            pictureCollectionViewHeightCons.constant = clvSize.height
            pictureCollectionViewWidthCons.constant = clvSize.width
            
            
            //10
            forwordText.text = viewModel?.forWordText
        }
    }
    

    func calculetRowHeight(viewModel: StatusViewModel) -> CGFloat {
        self.viewModel = viewModel
        self.layoutIfNeeded()
        return footerView.frame.maxY
    }
     // MARK: - 内部控制
    private func calculateSize() ->(CGSize,CGSize){
        
        //没有配图
        let count = viewModel?.thumbnail_pic?.count ?? 0
        if count == 0 {
        
            return (CGSize.zero,CGSize.zero)
        
        }
        
        //一张配图
        if count == 1 {
            let key = viewModel?.thumbnail_pic?.first!.absoluteString
            // 从缓存中获取已经下载好的图片
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            return ((image!.size),(image!.size))
            
        }
        
        //4张配图
        let imageW: CGFloat = 90
        let imageH: CGFloat = 90
        let imageMargin: CGFloat = 10
        if count == 4 {
            let col = 2
            let row = col
            //宽度 = 图片宽度 * 列数 + （列数 —— 1）* 间隙
            let width = imageW * CGFloat(col) + CGFloat(col - 1) * imageMargin
            //高度 = 图片高度 * 行数 + （行数 —— 1）* 间隙

            let height = imageH * CGFloat(row) + CGFloat(row - 1) * imageMargin
            
            return (CGSize(width: imageW, height: imageH),CGSize(width: width, height: height))
        }
        
        //其他张配图
        
        let col = 3
        let row = (count - 1) / 3 + 1
        let width = imageW * CGFloat(col) + CGFloat(col - 1) * imageMargin
        let height = imageH * CGFloat(row) + CGFloat(row - 1) * imageMargin
        
        return (CGSize(width: imageW, height: imageH),CGSize(width: width, height: height))
 
    }

    override func awakeFromNib() {
        super.awakeFromNib()
//        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2*10
        forwordText.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2*10
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

// MARK: - UICollectionViewDataSource实现数据源方法
extension HomeForWordTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let nib = UINib(nibName: "HomePicCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomePicCell")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePicCell", for: indexPath) as! HomePicCell
        cell.url = viewModel!.thumbnail_pic![indexPath.item]
        return cell
        
    }
}
