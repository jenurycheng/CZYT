//
//  AddGroupUserViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class AddGroupUserViewController: BasePortraitViewController {

    @IBOutlet weak var okBtn:UIButton!
    
    var detail:GroupDetail?
    var contact = [UserInfo]()
    var apiDataSource = ChatDataSource()
    var dataSource = ContactDataSource.sharedInstance
    var inGroupIds = [String]()
    var selectedIds = [String]()
    
    var selectContactView:SelectContactView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加成员"
        
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds  = true
        
        selectContactView = SelectContactView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64-45), selectMode:true)
        self.view.addSubview(selectContactView)
        
        self.update()
        // Do any additional setup after loading the view.
    }
    
    func update()
    {
        inGroupIds.removeAll()
        for u in detail!.users!
        {
            inGroupIds.append(u.userId!)
        }
        selectContactView.contactView.updateHiddenIds(inGroupIds)
    }
    
    @IBAction func okBtnClicked()
    {
        apiDataSource.joinGroup(selectContactView.contactView.selectedIds, groupId: self.detail!.groupId!, groupName: self.detail!.groupName!, success: { (result) in
            MBProgressHUD.showMessag("添加成功", toView: self.view.window, showTimeSec: 1)
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                MBProgressHUD.showMessag(error.msg, toView: self.view, showTimeSec: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}