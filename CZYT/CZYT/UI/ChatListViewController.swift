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
        self.conversationListTableView.frame = CGRect(x: 0, y: 64, width: GetSWidth(), height: GetSHeight()-64)
        self.title = "会话"
        self.automaticallyAdjustsScrollViewInsets = false
        self.conversationListTableView.separatorStyle = .singleLine
        
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
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        if model.conversationType == .ConversationType_GROUP {
            
            let chat = GroupConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
            chat?.title = model.conversationTitle
            self.navigationController?.pushViewController(chat!, animated: true)
        }else if model.conversationType == .ConversationType_PRIVATE{
            let chat = PrivateConversationViewController(conversationType: model.conversationType, targetId: model.targetId)
            chat?.title = model.conversationTitle
            self.navigationController?.pushViewController(chat!, animated: true)
        }
    }
    
    func removeCell(_ id:String?)
    {
        if Helper.isStringEmpty(id)
        {
            return
        }
        RCIMClient.shared().remove(.ConversationType_GROUP, targetId: id)
        self.refreshConversationTableViewIfNeeded()
    }
    
    override func didDeleteConversationCell(_ model: RCConversationModel!) {
        super.didDeleteConversationCell(model)
        if self.conversationListDataSource.count == 0 {
            self.conversationListTableView.separatorStyle = .none
        }else{
            self.conversationListTableView.separatorStyle = .singleLine
        }
    }
    
    override func willReloadTableData(_ dataSource: NSMutableArray!) -> NSMutableArray! {
        if dataSource.count == 0 {
            self.conversationListTableView.separatorStyle = .none
        }else{
            self.conversationListTableView.separatorStyle = .singleLine
        }
        return super.willReloadTableData(dataSource)
    }
}
