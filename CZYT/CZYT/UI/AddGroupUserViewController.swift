//
//  AddGroupUserViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class AddGroupUserViewController: BasePortraitViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var okBtn:UIButton!
    
    var detail:GroupDetail?
    var dataSource = ContactDataSource.sharedInstance
    var contact = [UserInfo]()
    var apiDataSource = ChatDataSource()
    
    var inGroupIds = [String]()
    var selectedIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "添加成员"
        
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds  = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        
        if dataSource.department.count == 0 || dataSource.contact.count == 0 {
            self.view.showHud()
        }
        dataSource.getDepartmentList({ (result) in
            self.dataSource.getContactList(UserInfo.sharedInstance.dept_id!, success: { (result) in
                DepartmentTree.sharedInstance().update(UserInfo.sharedInstance.dept_id!)
                self.view.dismiss()
                self.update()
                self.tableView.reloadData()
            }) { (error) in
                self.view.dismiss()
            }
        }) { (error) in
            self.view.dismiss()
        }
        
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
        
        contact.removeAll()
        for u in dataSource.contact
        {
            if !inGroupIds.contains(u.id!)
            {
                contact.append(u)
            }
        }
    }
    
    @IBAction func okBtnClicked()
    {
        apiDataSource.joinGroup(selectedIds, groupId: self.detail!.groupId!, groupName: self.detail!.groupName!, success: { (result) in
            MBProgressHUD.showMessag("邀请成功", toView: self.view.window, showTimeSec: 1)
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

extension AddGroupUserViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChatGroupCell
        let id = contact[indexPath.row].id!
        
        if inGroupIds.contains(id) {
            return
        }
        
        if selectedIds.contains(id) {
            cell.setChecked(false)
            selectedIds.removeAtIndex(selectedIds.indexOf(id)!)
        }else{
            cell.setChecked(true)
            selectedIds.append(id)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ChatGroupCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatGroupCell") as! ChatGroupCell
        cell.updateUserInfo(contact[indexPath.row])
        cell.selectionStyle = .None
        let id = contact[indexPath.row].id!
        if inGroupIds.contains(id) {
            cell.setChecked(true)
            cell.checkedImageView.alpha = 0.5
        }else{
            cell.setChecked(selectedIds.contains(id))
            cell.checkedImageView.alpha = 1
        }
        
        return cell
    }
}