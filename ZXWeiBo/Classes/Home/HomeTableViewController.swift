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
    
    var statusListModel = StatusListModel()
    
    
    private lazy var animatorManager = ZXPresentationManager()
    private lazy var titleBtn: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, for: .normal)
        btn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        return btn
    }()
    //下拉刷新提示文本的懒加载
    private lazy var tipLabel: UILabel = {

        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: ZXScreenWidth, height: 44))
        lb.backgroundColor = UIColor.orange
        lb.textColor = UIColor.white
        lb.textAlignment = NSTextAlignment.center
        lb.isHidden = true
        return lb
    }()
    
     var lastStatus = false
    
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
        
        tableView.separatorStyle = .none
        
       // 5、自定义下拉刷新
        refreshControl = ZXrefreshControl()
       
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        refreshControl?.beginRefreshing()
        
        // 提示刷新数据多少条
       navigationController?.navigationBar.insertSubview(tipLabel, at: 1)
        
    }
    deinit {
        //移除通知
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - 数据加载
    @objc func loadData() {
        statusListModel.loadData(lastStatus: lastStatus) { (models, error) in
            //安全校验
            if error != nil {
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            
            //刷新提醒
            self.showRefreshStatus(count: models!.count)
            
            //刷新表格
            self.tableView.reloadData()
            //关闭菊花
            self.refreshControl?.endRefreshing()

        }
        
        
    }
    //MARK: - 刷新提醒的动画
    private func showRefreshStatus(count: Int) {
        tipLabel.text = (count == 0) ? "没有跟多数据" : "刷新到\(count)条数据"
        tipLabel.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: 44)
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 1, options: .allowAnimatedContent, animations: {
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
            self.tipLabel.isHidden = true

            })
        }
    }
    
    @objc private func titleChanged() {
        titleBtn.isSelected = !titleBtn.isSelected
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
        return statusListModel.statuses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = statusListModel.statuses![indexPath.row]
        
        
        if indexPath.row == ((statusListModel.statuses?.count)! - 1) {
            lastStatus = true
            loadData()
            
        }
        
        
        if (viewModel.status.retweeted_status != nil) {
            let nib = UINib(nibName: "HomeForWordTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "forwordCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "forwordCell") as! HomeForWordTableViewCell
            cell.viewModel = viewModel
            return cell
        }else{
            let nib = UINib(nibName: "HomeTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "homeCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
            cell.viewModel = viewModel
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let viewModel = statusListModel.statuses![indexPath.row]
        if (viewModel.status.retweeted_status != nil) {
        guard let height = rowHeightCaches[viewModel.status.idstr!] else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "forwordCell") as! HomeForWordTableViewCell
            let temp = cell.calculetRowHeight(viewModel: viewModel)
            rowHeightCaches[viewModel.status.idstr!] = temp

            return temp
        }
        return height
        }
        else {
            guard let height = rowHeightCaches[viewModel.status.idstr!] else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
                let temp = cell.calculetRowHeight(viewModel: viewModel)
                rowHeightCaches[viewModel.status.idstr!] = temp
                
                return temp
            }
            return height
        }
    }
    
}


