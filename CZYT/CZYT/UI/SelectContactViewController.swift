//
//  SelectContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class SelectContactViewController: BasePortraitViewController {
    
    var callback:((selectedIds:[String])->Void)?
    
    var tableView:UITableView!
    var okBtn:UIButton!
    
    var dataSource = ContactDataSource.sharedInstance
    var contact = [UserInfo]()
    var apiDataSource = ChatDataSource()
    
    var selectedIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "指派员工"
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-50))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.view.addSubview(tableView)
        
        okBtn = UIButton(frame: CGRect(x: 10, y: GetSHeight()-64-45, width: GetSWidth()-20, height: 40))
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.setTitle("确定", forState: .Normal)
        okBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        okBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        okBtn.addTarget(self, action: #selector(SelectContactViewController.okBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(okBtn)
        
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
        contact.removeAll()
        for u in dataSource.contact
        {
            if u.id != UserInfo.sharedInstance.id
            {
                contact.append(u)
            }
        }
    }
    
    func addCallback(callback:((selectedIds:[String])->Void)?)
    {
        self.callback = callback
    }
    
    func okBtnClicked()
    {
        if selectedIds.count == 0
        {
            MBProgressHUD.showMessag("至少选择一位主办人", toView: self.view, showTimeSec: 1)
            return
        }
        if callback != nil
        {
            callback!(selectedIds:selectedIds)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelectContactViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactCell
        let id = contact[indexPath.row].id!
        
        if selectedIds.contains(id) {
            cell.setChecked(false)
            selectedIds.removeAtIndex(selectedIds.indexOf(id)!)
        }else{
            if selectedIds.count > 1
            {
                MBProgressHUD.showMessag("最多选择一个主办人和协办人", toView: self.view, showTimeSec: 1)
                return
            }
            cell.setChecked(true)
            selectedIds.append(id)
        }
        
        self.updateBtn()
    }
    
    func updateBtn()
    {
        var name = ""
        
        if selectedIds.count > 0
        {
            let u = ContactDataSource.sharedInstance.getUserInfo(selectedIds[0])
            let n = u == nil ? "" : u!.nickname!
            name = "主办人:" + n
        }
        
        if selectedIds.count > 1
        {
            let u = ContactDataSource.sharedInstance.getUserInfo(selectedIds[1])
            let n = u == nil ? "" : u!.nickname!
            name = name + "，协办人:" + n
        }
        if !Helper.isStringEmpty(name)
        {
            okBtn.setTitle("确定(\(name))", forState: .Normal)
        }else{
            okBtn.setTitle("确定", forState: .Normal)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        cell.updateUserInfo(contact[indexPath.row])
        cell.selectionStyle = .None
        let id = contact[indexPath.row].id!
        cell.setChecked(selectedIds.contains(id))
        cell.checkedImageView.alpha = 1
        
        return cell
    }
}
