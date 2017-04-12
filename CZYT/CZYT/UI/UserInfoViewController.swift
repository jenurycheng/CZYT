//
//  UserInfoViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserInfoViewController: BasePortraitViewController {

    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var headerBtn:UIButton?
    @IBOutlet weak var logoutBtn:UIButton?
    @IBOutlet weak var nameLabel:UILabel?
    
    var pushToVC:UIViewController?
    var loginViewController:UserLoginViewController?
    var dataSource = UserDataSource()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = "个人信息"
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.separatorStyle = .none
        
        logoutBtn!.layer.cornerRadius = 5
        logoutBtn!.layer.masksToBounds = true
        logoutBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        headerBtn!.layer.cornerRadius = 35
        headerBtn!.layer.masksToBounds = true
        
        self.updateInfo()
        // Do any additional setup after loading the view.
    }
    
    func updateInfo()
    {
        self.nameLabel!.text = UserInfo.sharedInstance.nickname
        if !Helper.isStringEmpty(UserInfo.sharedInstance.logo_path) {
            self.headerBtn!.sd_setImage(with: URL(string: UserInfo.sharedInstance.logo_path!), for: UIControlState(), placeholderImage: UIImage(named: "user_header_default"))
        }
    }
    
    var imagePicker:ImagePickerHelper?
    @IBAction func headerBtnClicked()
    {
        if imagePicker == nil
        {
            imagePicker = ImagePickerHelper()
        }
        
        unowned let weakSelf = self
        imagePicker?.show(self, callback: { (images) in
            if images.count == 0
            {
                return
            }
            let image = images[0] as! UIImage
            weakSelf.dataSource.updateUserPhoto(image, success: { (result) in
                UserInfo.sharedInstance.logo_path = result.logo_path
                let info = RCUserInfo(userId: UserInfo.sharedInstance.id, name: UserInfo.sharedInstance.nickname, portrait: result.logo_path)
                RCIM.shared().refreshUserInfoCache(info, withUserId: UserInfo.sharedInstance.id)
                weakSelf.updateInfo()
                }, failure: { (error) in
                    MBProgressHUD.showError(error.msg, to: self.view)
            })
        })
    }
    
    deinit
    {
        UserInfo.sharedInstance.removeObserver(self, forKeyPath: "isLogin")
    }
    
    @IBAction func logoutBtnClicked()
    {
        let alert = UIAlertView(title: "", message: "确定退出登录？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.show()
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isLogin" {
            if UserInfo.sharedInstance.isLogin {
                self.title = "个人信息"
                self.nameLabel?.text = UserInfo.sharedInstance.nickname
                if !Helper.isStringEmpty(UserInfo.sharedInstance.logo_path) {
                    self.headerBtn?.sd_setImage(with: URL(string: UserInfo.sharedInstance.logo_path!), for: UIControlState(), placeholderImage: UIImage(named: "user_header_default"))
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserInfoViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            self.view.window?.showHud()
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().cleanDisk()
            SDImageCache.shared().clearDisk(onCompletion: { () -> Void in
                self.tableView!.reloadData()
                self.view.window?.dismiss()
                DispatchQueue.global().async {
                    NetWorkCache.clearCache()
                }
            })
        }else if indexPath.row == 1
        {

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        cell.textLabel?.text = ["清除缓存"][indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = ThemeManager.current().darkGrayFontColor
        let line = GetLineView(CGRect(x: 0, y: 49, width: GetSWidth(), height: 1))
        cell.addSubview(line)
        
        
        if indexPath.row == 0
        {
            let cache:Double = Double(String(format: "%.1f", Double(SDImageCache.shared().getSize())/1024.0/1024.0))!
            cell.detailTextLabel?.text = "\(cache)MB"
            cell.detailTextLabel?.textColor = ThemeManager.current().grayFontColor
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        }else{
            
        }
        
        return cell
    }
}

extension UserInfoViewController : UIAlertViewDelegate
{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 100
        {
            if buttonIndex == 1
            {
                
            }
        }else{
            if buttonIndex == 1
            {
                UserInfo.sharedInstance.isLogin = false
                if loginViewController == nil {
                    loginViewController = UserLoginViewController()
                }
                if !UserInfo.sharedInstance.isLogin
                {
                    let nav = self.navigationController
                    let newNav = UINavigationController(rootViewController: loginViewController!)
                    nav?.present(newNav, animated: true, completion: {
                    })
                }
                
                LaunchAdverScreen.show()
            }
        }
        
    }
}
