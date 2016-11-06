//
//  HomeViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class HomeViewController: BasePortraitViewController {
    
    var tabBarViewController:TabBarViewController!
    var tabBar:TabBar!
    
    var cartoonViewController:UIViewController!
    var storyViewController:UIViewController!
    var moreViewController:UIViewController!
    var appViewController:UIViewController!
    var shopViewController:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = nil
        self.automaticallyAdjustsScrollViewInsets = false
        self.initViewController()
        
        tabBarViewController = TabBarViewController()
        tabBarViewController.viewControllers = [cartoonViewController, storyViewController,
                                                appViewController, shopViewController]
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
    }
    
    func initViewController()
    {
        cartoonViewController = UIViewController()
        cartoonViewController.title = "首页"
        storyViewController = UIViewController()
        storyViewController.title = "督办"
        moreViewController = UIViewController()
        appViewController = UIViewController()
        appViewController.title = "会话"
        shopViewController = UIViewController()
        shopViewController.title = "我的"
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
extension HomeViewController : TabBarDelegate
{
    
    func tabBarClickedIndex(tabBar: TabBar, index: Int) {
        tabBarViewController.showIndex(index)
        self.title = ["首页", "督办", "会话", "我的"][index]
    }
}
