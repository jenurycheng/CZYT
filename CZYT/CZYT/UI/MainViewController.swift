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
    
    var dataSource = UserDataSource()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .new, context: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "isLogin", options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //检查登录
        if !UserInfo.sharedInstance.isLogin
        {
            let nav = self.navigationController
            let user = UserLoginViewController()
//            user.pushToVC = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
            let newNav = UINavigationController(rootViewController: user)
            nav?.present(newNav, animated: true, completion: {
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
        tabBarViewController.view.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64)
        
        tabBar = TabBar(frame: CGRect(x: 0, y: GetSHeight() - 49 - 64, width: GetSWidth(), height: 49))
        tabBar.delegate = self
//        self.view.addSubview(tabBar)
        
//        let leftItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "home_user")))
        let userItem = UIBarButtonItem(image: UIImage(named: "home_user"), style: .plain, target: self, action: #selector(MainViewController.userItemClicked))
        self.navigationItem.rightBarButtonItem = userItem
        
        self.title = "成资合作"
        
        tabBarViewController.showIndex(0)
        
        var dic = Dictionary<String, AnyObject>()
        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
        dic.updateValue(UIFont.systemFont(ofSize: 22), forKey: NSFontAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = dic
    }
    
    deinit{
        UserInfo.sharedInstance.removeObserver(self, forKeyPath: "isLogin")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
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
            self.navigationController?.present(newNav, animated: true, completion: nil)
            return
        }
        let task = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
        self.navigationController?.pushViewController(task, animated: true)
    }
    
    func connectRM()
    {
        
        RCIM.shared().connect(withToken: UserInfo.sharedInstance.token, success: { (userId) -> Void in
            print("登陆成功。当前登录的用户ID：\(userId)")
            self.homeViewController.getUnreadMsg()
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
                DispatchAfter(10, queue: DispatchQueue.main, block: { 
                    UserDataSource().getToken({ (result) in
                        UserInfo.sharedInstance.token = result
                        self.connectRM()
                    }) { (error) in
                        MBProgressHUD.showMessag(error.msg, to: self.view, showTimeSec: 1)
                    }
                })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var dic = Dictionary<String, AnyObject>()
        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
        dic.updateValue(UIFont(name: "Helvetica-Bold", size: 21)!, forKey: NSFontAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = dic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        var dic = Dictionary<String, AnyObject>()
//        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
//        dic.updateValue(UIFont(name: "Helvetica-Bold", size: 18)!, forKey: NSFontAttributeName)
//        self.navigationController?.navigationBar.titleTextAttributes = dic
    }
    
    func initViewController()
    {
        homeViewController = HomeViewController()
        homeViewController.title = "成资合作"
        doneViewController = UIViewController()
        doneViewController.title = "督办"
        chatViewController = ChatListViewController()
        chatViewController.title = "会话"
        userViewController = UIViewController()
        userViewController.title = "我的"
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func tabBarClickedIndex(_ tabBar: TabBar, index: Int) {
        tabBarViewController.showIndex(index)
        self.title = ["成资合作", "督办", "会话", "我的"][index]
    }
}
