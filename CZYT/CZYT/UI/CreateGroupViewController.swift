//
//  CreateGroupViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/15.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class CreateGroupViewController: BasePortraitViewController {

    var dataSource = ContactDataSource.sharedInstance
    var apiDataSource = ChatDataSource()
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var createBtn:UIButton!
    
    var selectedIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建讨论组"
        self.view.backgroundColor = ThemeManager.current().backgroundColor
        createBtn.backgroundColor = ThemeManager.current().mainColor
        createBtn.layer.cornerRadius = 5
        createBtn.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        
        nameTextField.addTarget(self, action: #selector(CreateGroupViewController.endEdit), forControlEvents: .EditingDidEndOnExit)
        
        selectedIds.append(UserInfo.sharedInstance.id!)
        
        if dataSource.department.count == 0 || dataSource.contact.count == 0 {
            self.view.showHud()
        }
        dataSource.getDepartmentList({ (result) in
            self.dataSource.getContactList(UserInfo.sharedInstance.dept_id!, success: { (result) in
                DepartmentTree.sharedInstance().update(UserInfo.sharedInstance.dept_id!)
                self.view.dismiss()
                self.tableView.reloadData()
            }) { (error) in
                self.view.dismiss()
            }
        }) { (error) in
            self.view.dismiss()
        }
        // Do any additional setup after loading the view.
    }
    
    func endEdit()
    {
        self.nameTextField.resignFirstResponder()
    }
    
    @IBAction func create()
    {
        if Helper.isStringEmpty(nameTextField.text)  {
            MBProgressHUD.showMessag("请输入名称", toView: self.view, showTimeSec: 1)
            return
        }
        
        if selectedIds.count == 0 {
            MBProgressHUD.showMessag("请选择要加入的群成员", toView: self.view, showTimeSec: 1)
            return
        }
        
        self.view.showHud()
        apiDataSource.createGroup(selectedIds, groupName: nameTextField.text!, success: { (result) in
            self.view.dismiss()
            MBProgressHUD.showMessag("创建成功", toView: self.view.window, showTimeSec: 1)
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                self.view.dismiss()
                MBProgressHUD.showMessag(error.msg, toView: self.view, showTimeSec: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CreateGroupViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.contact.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactCell
        let id = dataSource.contact[indexPath.row].id!
        //如果是自己不取消
        if selectedIds.contains(id) {
            if id != UserInfo.sharedInstance.id
            {
                cell.setChecked(false)
                selectedIds.removeAtIndex(selectedIds.indexOf(id)!)
            }
        }else{
            cell.setChecked(true)
            selectedIds.append(id)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ContactCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        cell.updateUserInfo(dataSource.contact[indexPath.row])
        cell.selectionStyle = .None
        cell.setChecked(selectedIds.contains(dataSource.contact[indexPath.row].id!))
        return cell
    }
}
