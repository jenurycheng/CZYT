//
//  MainViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MainViewController: BasePortraitViewController {
    
    var tabBarViewController:TabBarViewController!
    var tabBar:TabBar!
    
    var homeViewController:HomeViewController!
    var doneViewController:UIViewController!
    var chatViewController:ChatListViewController!
    var userViewController:UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .New, context: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .New, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserInfo.sharedInstance.isLogin
        {
            let nav = self.navigationController
            let user = UserLoginViewController()
//            user.pushToVC = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
            let newNav = UINavigationController(rootViewController: user)
            nav?.presentViewController(newNav, animated: true, completion: {
            })
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = nil
        self.automaticallyAdjustsScrollViewInsets = false
        self.initViewController()
        
        tabBarViewController = TabBarViewController()
        tabBarViewController.viewControllers = [homeViewController, doneViewController,
                                                chatViewController, userViewController]
        self.addChildViewController(tabBarViewController)
        self.view.addSubview(tabBarViewController.view)
        tabBarViewController.view.frame = CGRectMake(0, 0, GetSWidth(), GetSHeight()-64)
        
        tabBar = TabBar(frame: CGRectMake(0, GetSHeight() - 49 - 64, GetSWidth(), 49))
        tabBar.delegate = self
//        self.view.addSubview(tabBar)
        
//        let leftItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "home_user")))
        let userItem = UIBarButtonItem(image: UIImage(named: "home_user"), style: .Plain, target: self, action: #selector(MainViewController.userItemClicked))
        self.navigationItem.rightBarButtonItem = userItem
        
        self.title = "成资一体化"
        tabBarViewController.showIndex(0)
    }
    
    deinit{
        UserInfo.sharedInstance.removeObserver(self, forKeyPath: "isLogin")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath != nil && keyPath == "isLogin"
        {
            if UserInfo.sharedInstance.isLogin
            {
                self.connectRM()
            }
        }
    }
    
    func userItemClicked()
    {
        if !UserInfo.sharedInstance.isLogin {
            let user = UserLoginViewController()
            user.pushToVC = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
            let newNav = UINavigationController(rootViewController: user)
            self.navigationController?.presentViewController(newNav, animated: true, completion: nil)
            return
        }
        let task = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
        self.navigationController?.pushViewController(task, animated: true)
    }
    
    func connectRM()
    {
        
        RCIM.sharedRCIM().connectWithToken(UserInfo.sharedInstance.token, success: { (userId) -> Void in
            print("登陆成功。当前登录的用户ID：\(userId)")
            self.homeViewController.getUnreadMsg()
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
                
                UserDataSource().getToken({ (result) in
                    UserInfo.sharedInstance.token = result
                    self.connectRM()
                }) { (error) in
                    MBProgressHUD.showMessag(error.msg, toView: self.view, showTimeSec: 1)
                }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initViewController()
    {
        homeViewController = HomeViewController()
        homeViewController.title = "成资一体化"
        doneViewController = UIViewController()
        doneViewController.title = "督办"
        chatViewController = ChatListViewController()
        chatViewController.title = "会话"
        userViewController = UIViewController()
        userViewController.title = "我的"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: TabBarDelegate
extension MainViewController : TabBarDelegate
{
    
    func tabBarClickedIndex(tabBar: TabBar, index: Int) {
        tabBarViewController.showIndex(index)
        self.title = ["成资一体化", "督办", "会话", "我的"][index]
    }
}
