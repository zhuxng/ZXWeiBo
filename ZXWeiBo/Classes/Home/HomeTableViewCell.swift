//
//  HomeTableViewCell.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/17.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
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
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2*10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
