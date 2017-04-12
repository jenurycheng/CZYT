//
//  ApproveDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/26.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ApproveDetailViewController: BasePortraitViewController {

    var id:String?
    var tableView:UITableView!
    var dataSource = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "批示详情"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-104))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        self.view.addSubview(tableView)
        tableView.register(UINib(nibName: "BBSTopDetailCell", bundle: nil), forCellReuseIdentifier: "BBSTopDetailCell")
        tableView.register(UINib(nibName: "BBSCommentCell", bundle: nil), forCellReuseIdentifier: "BBSCommentCell")
        tableView.register(UINib(nibName: "BBSCommentChildCell", bundle: nil), forCellReuseIdentifier: "BBSCommentChildCell")
        
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf.loadDetal()
        })
        
        self.loadDetal()
        
        let commentView = UIView(frame: CGRect(x: 0, y: GetSHeight()-40-64, width: GetSWidth(), height: 40))
        commentView.backgroundColor = ThemeManager.current().backgroundColor
        self.view.addSubview(commentView)
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: 0.5))
        line.backgroundColor = ThemeManager.current().lightGrayFontColor
        commentView.addSubview(line)
        
        let text = UITextField(frame: CGRect(x: 10, y: 8, width: GetSWidth()-20, height: 24))
        text.textColor = ThemeManager.current().lightGrayFontColor
        text.text = "  回复"
        text.layer.cornerRadius = 3
        text.layer.masksToBounds = true
        text.font = UIFont.systemFont(ofSize: 13)
        text.backgroundColor = ThemeManager.current().foregroundColor
        text.isEnabled = false
        commentView.addSubview(text)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BBSDetailViewController_New.tapped))
        commentView.isUserInteractionEnabled = true
        commentView.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func tapped()
    {
        KeyboardInputView.shareInstance().inputTextView.placeholder = "回复:"
        self.showInput()
    }
    
    func loadDetal()
    {
        self.view.showHud()
        dataSource.getApproveDetail(self.id!, success: { (result) in
            self.tableView.reloadData()
            self.view.dismiss()
            self.tableView.mj_header.endRefreshing()
            }) { (error) in
                self.view.dismiss()
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showInput()
    {
        KeyboardInputView.shareInstance().show { (text) in
            self.comment(text)
        }
    }
    
    func comment(_ text:String)
    {
        if Helper.isStringEmpty(text)
        {
            MBProgressHUD.showMessag("内容不能为空", to: self.view.window, showTimeSec: 1)
            return
        }
        self.view.showHud()
        self.dataSource.replyApprove(self.id!, content: text, success: {
            self.view.dismiss()
            KeyboardInputView.shareInstance().inputTextView.text = ""
            KeyboardInputView.shareInstance().hide()
            MBProgressHUD.showMessag("回复成功", to: self.view, showTimeSec: 1)
            self.loadDetal()

        }) { (data) in
            self.view.dismiss()
        }
    }
    
}

extension ApproveDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if dataSource.approveDetail == nil
            {
                return 0
            }
            return 1
        }else{
            if dataSource.approveDetail?.comments?.count == nil {
                return 0
            }
            return dataSource.approveDetail!.comments!.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let type = dataSource.approveDetail?.advice_type
            if type == "1"
            {
                let project = ProjectWorkDetailViewController_New()
                project.id = dataSource.approveDetail!.advice_ref_id!
                project.hiddenItem = true
                self.navigationController?.pushViewController(project, animated: true)
            }else if type == "2"
            {
                let status = WorkStatusDetailViewController()
                status.id = dataSource.approveDetail!.advice_ref_id!
                status.hiddenItem = true
                self.navigationController?.pushViewController(status, animated: true)
            }
        }
//        else if indexPath.section > 0 {
//            if indexPath.row == 0 {
//                let toName = dataSource.bbsComment[indexPath.section-1].publish_user_name == nil ? "" : dataSource.bbsComment[indexPath.section-1].publish_user_name!
//                KeyboardInputView.shareInstance().inputTextView.placeholder = "回复:\(toName)"
//                self.toId = dataSource.bbsComment[indexPath.section-1].publish_user_id
//                self.toCommentID = dataSource.bbsComment[indexPath.section-1].comment_id!
//                self.showInput()
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BBSTopDetailCell") as! BBSTopDetailCell
            cell.titleLabel.numberOfLines = 0
            cell.detailLabel?.numberOfLines = 0
            if dataSource.approveDetail != nil
            {
                cell.updateApproveDetail(dataSource.approveDetail!)
            }
            return cell
        }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCommentCell") as! BBSCommentCell
                cell.updateApproveComment(dataSource.approveDetail!.comments![indexPath.row])
                return cell
        }
        
    }

}
