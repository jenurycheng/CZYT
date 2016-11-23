//
//  PublishTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishTaskViewController: BasePortraitViewController {

    @IBOutlet weak var titleTextField:UITextField!
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var publishBtn:UIButton!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    var selectedIds = [String]()
    var endDate:String?
    
    var dataSource = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "发布任务"
        
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight() - 64
        
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = ThemeManager.current().backgroundColor.CGColor
        titleTextField.addTarget(self, action: #selector(PublishTaskViewController.endEdit), forControlEvents: .EditingDidEndOnExit)
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.CGColor
        
        publishBtn.backgroundColor = ThemeManager.current().mainColor
        publishBtn.layer.cornerRadius = 5
        publishBtn.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        self.titleLabel.addGestureRecognizer(tap1)
        self.contentLabel.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    
    func endEdit()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func publishBtnClicked()
    {
        if Helper.isStringEmpty(titleTextField.text)
        {
            MBProgressHUD.showMessag("输入任务标题", toView: self.view, showTimeSec: 1)
            return
        }
        if Helper.isStringEmpty(contentTextView.text)
        {
            MBProgressHUD.showMessag("输入任务内容", toView: self.view, showTimeSec: 1)
            return
        }
        
        if selectedIds.count == 0 {
            MBProgressHUD.showMessag("选择指派对象", toView: self.view, showTimeSec: 1)
            return
        }
        
        if endDate == nil {
            MBProgressHUD.showMessag("选择截止日期", toView: self.view, showTimeSec: 1)
            return
        }
        let task = PublishTask()
        task.task_title = titleTextField.text
        task.task_content = contentTextView.text
        task.director = selectedIds[0]
        if selectedIds.count > 1
        {
            task.supporter = selectedIds[1]
        }else{
            task.supporter = ""
        }
        task.task_end_date = endDate
        
        self.view.showHud()
        dataSource.publishTask(task, success: { (result) in
            self.view.dismiss()
            MBProgressHUD.showSuccess("发布成功", toView: self.view.window)
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                self.view.dismiss()
                MBProgressHUD.showError(error.msg, toView: self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PublishTaskViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0
        {
            let s = SelectContactViewController()
            for i in self.selectedIds
            {
                s.selectedIds.append(i)
            }
            unowned let weakSelf = self
            s.addCallback({ (selectedIds) in
                weakSelf.selectedIds.removeAll()
                let cell = tableView.cellForRowAtIndexPath(indexPath)
                var name = ""
                
                for id in selectedIds
                {
                    let u = ContactDataSource.sharedInstance.getUserInfo(id)
                    let n = u == nil ? "" : u!.nickname!
                    name = name + n + ","
                    weakSelf.selectedIds.append(id)
                }
                if name.characters.count > 0
                {
                    name = name.substringToIndex(name.endIndex.advancedBy(-1))
                }
                
                cell?.detailTextLabel?.text = name
            })
            self.navigationController?.pushViewController(s, animated: true)
        }else if indexPath.row == 1{
            unowned let weakSelf = self
            DatePickerDialog().show("选择截止日期", datePickerMode: UIDatePickerMode.DateAndTime) { (date) in
                let formmater = NSDateFormatter()
                formmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let d = formmater.stringFromDate(date)
                let cell = weakSelf.tableView.cellForRowAtIndexPath(indexPath)
                cell?.detailTextLabel?.text = d
                weakSelf.endDate = d
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        if indexPath.row == 0 {
            cell.textLabel?.text = "指派给"
            let line = GetLineView(CGRect(x: 0, y: 39, width: GetSWidth(), height: 1))
            cell.addSubview(line)
        }else if indexPath.row == 1
        {
            cell.textLabel?.text = "截止日期"
        }
        return cell
    }
}
