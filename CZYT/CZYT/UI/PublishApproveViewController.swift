//
//  PublishApproveViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishApproveViewController: BasePortraitViewController {

    var id:String?
    var type:String?
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var publishBtn:UIButton!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var tableView:UITableView!
    
    var dataSource = TaskDataSource()
    var selectedIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加批示"
        
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight() - 64
        
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

        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishApproveViewController.endEdit))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PublishApproveViewController.endEdit))
        self.contentLabel.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    
    override func backItemBarClicked(_ item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder
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
        if Helper.isStringEmpty(contentTextView.text)
        {
            MBProgressHUD.showMessag("请输入内容", to: self.view, showTimeSec: 1)
            return
        }
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
        dataSource.publishApprove(self.contentTextView.text, advice_type: self.type!, advice_ref_id: self.id!, assigns:assigns, success: {
            MBProgressHUD.showSuccess("批示成功", to: self.view.window)
            ApproveListViewController.needUpdate = true
            self.navigationController?.popViewController(animated: true)
            }) { (error) in
                MBProgressHUD.showError("批示出错", to: self.view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PublishApproveViewController : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
