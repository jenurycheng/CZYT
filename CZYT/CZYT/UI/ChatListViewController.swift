//
//  ChatListViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/7.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatListViewController: RCConversationListViewController {
    override func viewDidLoad() {
        //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.conversationListTableView.separatorStyle = .SingleLine
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_CHATROOM.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        //self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
        //    RCConversationType.ConversationType_GROUP.rawValue])
    }
    
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, atIndexPath indexPath: NSIndexPath!) {
        //打开会话界面
        if model.conversationType == .ConversationType_GROUP {
            
            let chat = GroupConversationViewController()
            chat.conversationType = model.conversationType
            chat.targetId = model.targetId
            chat.title = model.conversationTitle
            self.navigationController?.pushViewController(chat, animated: true)
        }else if model.conversationType == .ConversationType_PRIVATE{
            let chat = RCConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
            chat.title = model.conversationTitle
            self.navigationController?.pushViewController(chat, animated: true)
        }
        
    }
    
//    override func rcConversationListTableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> RCConversationBaseCell! {
//        let cell = super.rcConversationListTableView(tableView, cellForRowAtIndexPath: indexPath)
//        let height = self.rcConversationListTableView(tableView, heightForRowAtIndexPath: indexPath)
//        let line = GetLineView(CGRect(x: 0, y: height-1, width: GetSWidth(), height: 1))
//        cell.addSubview(line)
//        return cell
//    }
}
