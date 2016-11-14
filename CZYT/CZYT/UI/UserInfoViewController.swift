//
//  UserInfoViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerBtn:UIButton!
    @IBOutlet weak var logoutBtn:UIButton!
    @IBOutlet weak var nameLabel:UILabel!
    
    var loginViewController:UserLoginViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = "个人信息"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        
        logoutBtn.layer.cornerRadius = 5
        logoutBtn.layer.masksToBounds = true
        logoutBtn.titleLabel?.font = UIFont.systemFontOfSize(17)
        
        if !UserInfo.sharedInstance.isLogin {
            loginViewController = UserLoginViewController()
            self.addChildViewController(loginViewController!)
            self.view.addSubview(loginViewController!.view)
            self.title = "登录"
        }
        
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .New, context: nil)
        // Do any additional setup after loading the view.
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "isLogin" {
            if UserInfo.sharedInstance.isLogin {
                self.title = "个人信息"
                self.nameLabel.text = UserInfo.sharedInstance.nickname
                if !Helper.isStringEmpty(UserInfo.sharedInstance.logo_path) {
                    self.headerBtn.sd_setImageWithURL(NSURL(string: UserInfo.sharedInstance.logo_path!), forState: .Normal, placeholderImage: UIImage(named: "user_header_default"))
                }
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "")
        cell.textLabel?.text = ["清除缓存", "关于我们"][indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.textColor = ThemeManager.current().darkGrayFontColor
        let line = GetLineView(CGRect(x: 0, y: 49, width: GetSWidth(), height: 1))
        cell.addSubview(line)
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        return cell
    }
}

extension UserInfoViewController : UIAlertViewDelegate
{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            UserInfo.sharedInstance.isLogin = false
            if loginViewController == nil {
                loginViewController = UserLoginViewController()
            }
            self.addChildViewController(loginViewController!)
            self.view.addSubview(loginViewController!.view)
        }
    }
}
