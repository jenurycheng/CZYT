//
//  PublishTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishTaskViewController: BasePortraitViewController {

    var taskID:String?
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
        titleTextField.layer.borderColor = ThemeManager.current().backgroundColor.cgColor
        titleTextField.addTarget(self, action: #selector(PublishTaskViewController.endEdit), for: .editingDidEndOnExit)
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.cgColor
        
        publishBtn.backgroundColor = ThemeManager.current().mainColor
        publishBtn.layer.cornerRadius = 5
        publishBtn.layer.masksToBounds = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        self.titleLabel.addGestureRecognizer(tap1)
        self.contentLabel.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    
    override func backItemBarClicked(_ item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder || self.titleTextField.isFirstResponder
        {
            self.endEdit()
        }else{
            super.backItemBarClicked(item)
        }
    }
    
    func endEdit()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func publishBtnClicked()
    {
//        if Helper.isStringEmpty(titleTextField.text)
//        {
//            MBProgressHUD.showMessag("输入任务标题", to: self.view, showTimeSec: 1)
//            return
//        }
        if Helper.isStringEmpty(contentTextView.text)
        {
            MBProgressHUD.showMessag("输入任务内容", to: self.view, showTimeSec: 1)
            return
        }
        
        if selectedIds.count == 0 {
            MBProgressHUD.showMessag("选择接收人员", to: self.view, showTimeSec: 1)
            return
        }
        
        if endDate == nil {
            MBProgressHUD.showMessag("选择截止日期", to: self.view, showTimeSec: 1)
            return
        }
        let task = PublishTask()
        task.task_title = ""//titleTextField.text
        task.task_content = contentTextView.text
        task.task_projectwork_id = taskID
//        task.director = selectedIds[0]
//        if selectedIds.count > 1
//        {
//            task.supporter = selectedIds[1]
//        }else{
//            task.supporter = ""
//        }
        var assigns = ""
        for id in selectedIds
        {
            if id != selectedIds[selectedIds.count-1]
            {
                assigns = assigns + id + ","
            }else{
                assigns = assigns + id
            }
        }
        task.assigns = assigns
        task.task_end_date = endDate
        
        self.view.showHud()
        dataSource.publishTask(task, success: { (result) in
            self.view.dismiss()
            MyTaskViewController.shouldReload = true
            MyPublishTaskViewController.shouldReload = true
            MBProgressHUD.showSuccess("发布成功", to: self.view.window)
            self.navigationController?.popViewController(animated: true)
            }) { (error) in
                self.view.dismiss()
                MBProgressHUD.showError(error.msg, to: self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PublishTaskViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
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
                let cell = tableView.cellForRow(at: indexPath)
                var name = ""
                
                if selectedIds.count > 0
                {
                    for id in selectedIds
                    {
                        let u = ContactDataSource.sharedInstance.getUserInfo(id)
                        let n = u == nil ? "" : u!.nickname!
                        if id != selectedIds[selectedIds.count-1]
                        {
                            name = name + n + ","
                        }else{
                            name = name + n
                        }
                        
                    }
                }
                
                weakSelf.selectedIds.append(contentsOf: selectedIds)
                
                cell?.detailTextLabel?.text = name
            })
            self.navigationController?.pushViewController(s, animated: true)
        }else if indexPath.row == 1{
            unowned let weakSelf = self
            DatePickerDialog().show("选择截止日期", datePickerMode: UIDatePickerMode.date) { (date) in
                let formmater = DateFormatter()
                formmater.dateFormat = "yyyy-MM-dd"
                let d = formmater.string(from: date)
                let cell = weakSelf.tableView.cellForRow(at: indexPath)
                cell?.detailTextLabel?.text = d
                weakSelf.endDate = d
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.textLabel?.text = "接收人员"
            let line = GetLineView(CGRect(x: 0, y: 39, width: GetSWidth(), height: 1))
            cell.addSubview(line)
        }else if indexPath.row == 1
        {
            cell.textLabel?.text = "截止日期"
        }
        return cell
    }
}
