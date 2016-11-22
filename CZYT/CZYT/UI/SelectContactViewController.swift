//
//  SelectContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class SelectContactViewController: UIViewController {
    
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
        tableView.registerNib(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        self.view.addSubview(tableView)
        
        okBtn = UIButton(frame: CGRect(x: 10, y: GetSHeight()-64-45, width: GetSWidth()-20, height: 40))
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.setTitle("确定", forState: .Normal)
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
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ChatGroupCell
        let id = contact[indexPath.row].id!
        
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
        cell.setChecked(selectedIds.contains(id))
        cell.checkedImageView.alpha = 1
        
        return cell
    }
}
