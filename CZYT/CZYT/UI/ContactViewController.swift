//
//  ContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ContactViewController: BasePortraitViewController {

    var contactDataSource = ContactDataSource.sharedInstance
    
    var sideView:CCSideView!
    var departmentView:DepartmentListView!
    var contactView:ContactListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        departmentView = DepartmentListView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        departmentView.delegate = self
        contactView = ContactListView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        
        sideView = CCSideView(frame: self.view.bounds, leftView: departmentView, contentView: contactView)
        self.view.addSubview(sideView)
        self.getData()
        // Do any additional setup after loading the view.
    }
    
    func getData()
    {
        if contactDataSource.department.count == 0 || contactDataSource.contact.count == 0
        {
            self.view.showHud()
        }
        contactDataSource.getDepartmentList({ (result) in
            self.contactDataSource.getContactList(UserInfo.sharedInstance.dept_id!, success: { (result) in
                DepartmentTree.sharedInstance().update(UserInfo.sharedInstance.dept_id!)
                self.departmentView.update()
                self.contactView.update(UserInfo.sharedInstance.dept_id!)
                self.view.dismiss()
            }) { (error) in
                self.view.dismiss()
            }
        }) { (error) in
            self.view.dismiss()
        }
    }
    
    func btnClicked()
    {
        let chat = PrivateConversationViewController()
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        chat.targetId = "3"
        chat.title = "h"
        self.navigationController?.pushViewController(chat, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ContactViewController : DepartmentListViewDelegate
{
    func departmentSelected(depart: Department) {
        sideView.hide()
        contactView.update(depart.dept_id!)
    }
}
