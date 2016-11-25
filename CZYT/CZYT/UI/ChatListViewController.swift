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
        self.view.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64)
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
            
            let chat = GroupConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
            chat.title = model.conversationTitle
            self.navigationController?.pushViewController(chat, animated: true)
        }else if model.conversationType == .ConversationType_PRIVATE{
            let chat = PrivateConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
            chat.title = model.conversationTitle
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    func removeCell(id:String?)
    {
        if Helper.isStringEmpty(id)
        {
            return
        }
        RCIMClient.sharedRCIMClient().removeConversation(.ConversationType_GROUP, targetId: id)
        self.refreshConversationTableViewIfNeeded()
    }
    
    override func didDeleteConversationCell(model: RCConversationModel!) {
        super.didDeleteConversationCell(model)
        if self.conversationListDataSource.count == 0 {
            self.conversationListTableView.separatorStyle = .None
        }else{
            self.conversationListTableView.separatorStyle = .SingleLine
        }
    }
    
    override func willReloadTableData(dataSource: NSMutableArray!) -> NSMutableArray! {
        if dataSource.count == 0 {
            self.conversationListTableView.separatorStyle = .None
        }else{
            self.conversationListTableView.separatorStyle = .SingleLine
        }
        return super.willReloadTableData(dataSource)
    }
}
