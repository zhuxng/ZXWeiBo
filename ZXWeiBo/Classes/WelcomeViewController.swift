//
//  WelcomeViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/15.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImageView.layer.cornerRadius = 45
        userImageView.clipsToBounds = true
        assert(UserAccount.loadUserAccount() != nil, "必须先授权")
        guard let url = URL(string: (UserAccount.loadUserAccount()!.avatar_large!)) else {
            return
        }
        userImageView.sd_setImage(with: url)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        iconBottomCons.constant = UIScreen.main.bounds.height - 160
        UIView.animate(withDuration: 2, animations: {
            self.view.layoutIfNeeded()
            
        }) { (_) in
            UIView.animate(withDuration: 2.0, animations: {
                self.titleLable.alpha = 1.0
            }, completion: { (_) in
                
            })
        }
    }
}
