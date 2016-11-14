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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        self.title = "首页"
        tabBarViewController.showIndex(0)
        
        self.connectRM()
    }
    
    func userItemClicked()
    {
        let user = UserLoginViewController()
        self.navigationController?.pushViewController(user, animated: true)
    }
    
    func connectRM()
    {
//        +3i9YLmms0Vlo0WOqjkCmKu+rk3pHfBlLiZxdaWPzBpQh3owd4R7ha1AGJnuiVEzlWkFIf3uN/4mt6oaneb7Bw==  chester1
//        0TMdTxQX/vZlQTjG+6L7CaT/b2VGEz/XbOGONo0T2ZxYwbEFFXCsYVzsr1vWOjnggmm8vAmwCIunNQOmx70hlbcRJu5mXoUj  chester
//        RCIM.sharedRCIM().connectWithToken("+3i9YLmms0Vlo0WOqjkCmKu+rk3pHfBlLiZxdaWPzBpQh3owd4R7ha1AGJnuiVEzlWkFIf3uN/4mt6oaneb7Bw==",
//                                           success: { (userId) -> Void in
//                                            print("登陆成功。当前登录的用户ID：\(userId)")
//                                            
//                                            //新建一个聊天会话View Controller对象
//                                            let chat = RCConversationViewController()
//                                            //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
//                                            chat.conversationType = RCConversationType.ConversationType_PRIVATE
//                                            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//                                            chat.targetId = "chester1"
//                                            //设置聊天会话界面要显示的标题
//                                            chat.title = "想显示的会话标题"
//                                            //显示聊天会话界面
//                                            dispatch_async(dispatch_get_main_queue(), { 
//                                                self.navigationController?.pushViewController(chat, animated: true)
//                                            })
//                                            
//            }, error: { (status) -> Void in
//                print("登陆的错误码为:\(status.rawValue)")
//            }, tokenIncorrect: {
//                //token过期或者不正确。
//                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//                print("token错误")
//        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initViewController()
    {
        homeViewController = HomeViewController()
        homeViewController.title = "首页"
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
        self.title = ["首页", "督办", "会话", "我的"][index]
    }
}
