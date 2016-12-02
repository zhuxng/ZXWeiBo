//
//  HomePicCell.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/25.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit

class HomePicCell: UICollectionViewCell {

   
    
    @IBOutlet weak var customIconImageView: UIImageView!
    var url: URL?
        {
        didSet{
            customIconImageView.sd_setImage(with: url)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
