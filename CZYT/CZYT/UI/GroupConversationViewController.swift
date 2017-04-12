//
//  GroupConversationViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class GroupConversationViewController: RCConversationViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
    
        if conversationType == RCConversationType.ConversationType_GROUP
        {
            let groupItem = UIBarButtonItem(image: UIImage(named: "group_detail"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(GroupConversationViewController.groupItemClicked))
            self.navigationItem.rightBarButtonItem = groupItem
        }
        // Do any additional setup after loading the view.
        let backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
        
        self.chatSessionInputBarControl.pluginBoardView.removeItem(at: 2)
    }
    
    override func didTapCellPortrait(_ userId: String!) {
        if userId == UserInfo.sharedInstance.id
        {
            return
        }
        let chat = PrivateConversationViewController(conversationType: .ConversationType_PRIVATE, targetId: userId)
        UserDataSource().getUserDetail(userId, success: { (result) in
            chat?.title = result.nickname
        }) { (error) in
        }
        self.navigationController?.pushViewController(chat!, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.targetId != nil {
            ChatDataSource().queryGroupDetail(self.targetId!, success: { (result) in
                self.title = result.groupName
            }) { (error) in
                
            }
        }
    }
    
    func backItemBarClicked(_ item:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    func groupItemClicked()
    {
        let detail = GroupDetailViewController()
        detail.groupId = self.targetId
        self.navigationController?.pushViewController(detail, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
