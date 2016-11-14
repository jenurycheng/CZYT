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
        
        self.title = "消息"
        
        backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
        
        tabTitleView = CCTabTitleView(frame: CGRect(x: 40, y: 0, width: GetSWidth()-80, height: 44))
        tabTitleView.spacingLineHidden = true
        tabTitleView.font = UIFont.systemFontOfSize(Helper.scale(60))
        tabTitleView.selectTextColor = ThemeManager.current().whiteFontColor
        tabTitleView.delegate = self
        self.navigationItem.titleView = tabTitleView
        
        chatListVC = ChatListViewController()
        contactVC = ContactViewController()
        groupVC = GroupViewController()
        
        self.viewControllers = [chatListVC!, contactVC!, groupVC!]
        
        self.showIndex(0)
        // Do any additional setup after loading the view.
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
    
    func titleForPosition(pos: NSInteger) -> String! {
        return  ["消息", "联系人", "群组"][pos]
    }
    
    func titleViewIndexDidSelected(titleView: CCTabTitleView, index: Int) {
        self.showIndex(index)
        tabTitleView.updateLine(CGFloat(index)/3)
        
        self.title = ["消息", "联系人", "群组"][index]
    }
}
