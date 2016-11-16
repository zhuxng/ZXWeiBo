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
    var status: Status?
        {
        didSet{
            // 1.设置头像
            if let urlStr = status?.user?.profile_image_url
            {
                let url = NSURL(string: urlStr)
                iconImageView.sd_setImage(with: url as URL!)
            }
            // 2.设置认证图标
            
            // 3.设置昵称
            nameLabel.text = status?.user?.screen_name
            
            // 4.设置会员图标
            
            // 5.设置时间
            timeLabel.text = status?.created_at
            
            // 6.设置来源
            sourceLabel.text = status?.source
            
            // 7.设置正文
            contentLabel.text = status?.text
            iconImageView.layer.cornerRadius = 25
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 2*10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
