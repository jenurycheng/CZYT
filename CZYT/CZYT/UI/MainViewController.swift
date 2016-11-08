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
    var chatViewController:UIViewController!
    var userViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = nil
        self.automaticallyAdjustsScrollViewInsets = false
        self.initViewController()
        
        tabBarViewController = TabBarViewController()
        tabBarViewController.viewControllers = [homeViewController, doneViewController,
                                                chatViewController, userViewController]
        self.view.addSubview(tabBarViewController.view)
        self.addChildViewController(tabBarViewController)
        tabBarViewController.view.frame = CGRectMake(0, 0, GetSWidth(), GetSHeight()-49)
        
        tabBar = TabBar(frame: CGRectMake(0, GetSHeight() - 49, GetSWidth(), 49))
        tabBar.delegate = self
        self.view.addSubview(tabBar)
        
        self.title = "首页"
        tabBarViewController.showIndex(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let request = NetWorkHandle.NetWorkHandleApp.RequestLeaderActivity()
        request.classify = "成都"
        request.offset = "0"
        request.row_count = "10"
        NetWorkHandle.NetWorkHandleApp.getLeaderActivity(request) { (data) in
            if data.isSuccess()
            {
                print(data.data)
            }else{
                print(data.msg)
            }
            
        }
    }
    
    func initViewController()
    {
        homeViewController = HomeViewController()
        homeViewController.title = "首页"
        doneViewController = UIViewController()
        doneViewController.title = "督办"
        chatViewController = UIViewController()
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
        self.title = ["首页", "督办", "会话", "我的"][index]
    }
}
