//
//  HomeTableViewController.swift
//  ZXWeiBo
//
//  Created by 朱星 on 2016/11/2.
//  Copyright © 2016年 zhuxing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeTableViewController: BaseTableViewController {
    
    var isPresent = false
    ///保存所以微博数据
    var statuses: [StatusViewModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var animatorManager = ZXPresentationManager()
    private lazy var titleBtn: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(HomeTableViewController.titleBtnClick), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //判断是否登录
        if !isLogin {
            visitorView.setupVisitorInfo(imageName: nil, title: "关注一些人。回这里看有什么惊喜")
            return
        }
        //初始化导航条
        setupNav()
        
        //3注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChanged), name: NSNotification.Name(rawValue: ZXPresentationManagerDIdPresented), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.titleChanged), name: NSNotification.Name(rawValue: ZXPresentationManagerDIddismissed), object: nil)
        
        
        // 4、获取微博数据
        loadData()
        tableView.estimatedRowHeight = 400
    }
  
    
    private func loadData() {
        
        let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "homeCell")
        NetworkTools.shareInstance.loadStatuses { (array, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "获取数据失败")
            }
            //2、将字典转换成模型数组
            var models = [StatusViewModel]()
            guard let arr = array else {
                return
            }
            for dict in arr {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
//            self.statuses = models
            //4、缓存所有的配图
            self.cachesImages(viewModels: models)
        }
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func titleChanged() {
        titleBtn.isSelected = !titleBtn.isSelected
    }
    
    // MARK: - 图片缓存
    private func cachesImages(viewModels: [StatusViewModel]) {
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
        self.statuses = viewModels
        }
    }
    
    // MARK: - 内部控制
    func setupNav(){
        //MARK: - 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",target: self, action: #selector(HomeTableViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",target: self, action: #selector(HomeTableViewController.rigthBtnClick))
        
        //MARK: - 创建标题按钮
        navigationItem.titleView = titleBtn
    }
    @objc private func titleBtnClick(btn:UIButton)  {
        //MARK: - 通过UIStoryboard创建一个UIViewController
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        //MARK: - 以模态方式弹出UIViewController《从下忘上弹出》
        menuView.transitioningDelegate = animatorManager
        menuView.modalPresentationStyle = .custom
        present(menuView, animated: true)
    }
    
    @objc private func leftBtnClick(btn:UIButton) {
        
    }
    @objc private func rigthBtnClick(btn:UIButton) {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        guard let QRVC = sb.instantiateInitialViewController() else {
            return
        }
        present(QRVC, animated: true, completion: nil)
        
    }
    /// 缓存行高
    var rowHeightCaches = [String: CGFloat]()
    
}
extension HomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        cell.viewModel = statuses![indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = statuses![indexPath.row]
        guard let height = rowHeightCaches[viewModel.status.idstr!] else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
            let temp = cell.calculetRowHeight(viewModel: viewModel)
            rowHeightCaches[viewModel.status.idstr!] = temp

            return temp
        }
        return height
    }
    
}


