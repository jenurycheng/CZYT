//
//  ChatViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatViewController: TabBarViewController {

    var tabTitleView:CCTabTitleView!
    
    var chatListVC : ChatListViewController?
    var contactVC : ContactViewController?
    var groupVC : GroupViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = true
        self.title = "消息"
        
        backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
        
        tabTitleView = CCTabTitleView(frame: CGRect(x: 40, y: 0, width: GetSWidth()-80, height: 44))
        tabTitleView.spacingLineHidden = true
        tabTitleView.font = UIFont.systemFont(ofSize: Helper.scale(60))
        tabTitleView.selectTextColor = ThemeManager.current().whiteFontColor
        tabTitleView.delegate = self
        self.navigationItem.titleView = tabTitleView
        
        chatListVC = ChatListViewController()
        contactVC = ContactViewController()
        groupVC = GroupViewController()
        
        self.viewControllers = [chatListVC!, contactVC!, groupVC!]
        
        self.showIndex(0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.quitGroup), name: NSNotification.Name(rawValue: ChatDataSource.NOTIFICATION_QUIT_GROUP), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func quitGroup(_ notify:Notification)
    {
        if notify.userInfo != nil
        {
            let id = notify.userInfo!["id"] as? String
            chatListVC?.removeCell(id)
        }
        if self.navigationController!.viewControllers.contains(self) {
            self.navigationController?.popToViewController(self, animated: true)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ChatDataSource.NOTIFICATION_QUIT_GROUP), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChatViewController : CCTabTitleViewDelegate
{
    func titleCount() -> Int! {
        return 3
    }
    
    func titleForPosition(_ pos: NSInteger) -> String! {
        return  ["消息", "联系人", "讨论组"][pos]
    }
    
    func titleViewIndexDidSelected(_ titleView: CCTabTitleView, index: Int) {
        self.showIndex(index)
        tabTitleView.updateLine(CGFloat(index)/3)
        
        self.title = ["消息", "联系人", "讨论组"][index]
    }
}
