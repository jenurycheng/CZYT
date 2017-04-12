//
//  BBSDetailViewController_New.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/26.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class BBSDetailViewController_New: BasePortraitViewController {

    var id:String?
    var tableView:UITableView!
    var dataSource = BBSDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "建言献策"
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
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf.loadMore()
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
        text.text = "  添加评论"
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
        self.toId = nil
        self.toCommentID = "0"
        KeyboardInputView.shareInstance().inputTextView.placeholder = "评论:"
        self.showInput()
    }
    
    func loadDetal()
    {
        dataSource.getBBSDetail(self.id!, success: { (result) in
            self.tableView.reloadData()
            self.loadData()
            }) { (error) in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
        }
    }
    
    func loadData()
    {
        if dataSource.bbsComment.count == 0 {
            self.view.showHud()
        }
        dataSource.getBBSComment(true, id: self.id!, success: { (result) in
            self.view.dismiss()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
        }) { (error) in
            self.view.dismiss()
            self.tableView.mj_header.endRefreshing()
            NetworkErrorView.show(self.view, data: error, callback: {
                self.loadData()
            })
        }
    }
    
    func loadMore()
    {
        dataSource.getBBSComment(false, id: id!, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            if result.count == 0
            {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var toId:String?
    var toCommentID:String = "0"
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
        self.dataSource.addBBSComment(self.id!, content: text, userId: UserInfo.sharedInstance.id!, replyUserId: self.toId, parent_comment_id: toCommentID, success: { (result) in
            self.view.dismiss()
            KeyboardInputView.shareInstance().inputTextView.text = ""
            KeyboardInputView.shareInstance().hide()
            MBProgressHUD.showMessag("评论成功", to: self.view, showTimeSec: 1)
            
            self.loadData()
        }) { (error) in
            self.view.dismiss()
        }
    }
    
}

extension BBSDetailViewController_New : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 0
        if dataSource.bbsDetail != nil {
            num = 1
        }
        num = num + dataSource.bbsComment.count
        
        return num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            var num = 1
            if dataSource.bbsComment[section-1].children?.count != nil {
                num += dataSource.bbsComment[section-1].children!.count
            }
            return num
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.toId = nil
            self.toCommentID = "0"
            KeyboardInputView.shareInstance().inputTextView.placeholder = "评论:"
            self.showInput()
        }
        else if indexPath.section > 0 {
            if indexPath.row == 0 {
                let toName = dataSource.bbsComment[indexPath.section-1].publish_user_name == nil ? "" : dataSource.bbsComment[indexPath.section-1].publish_user_name!
                KeyboardInputView.shareInstance().inputTextView.placeholder = "回复:\(toName)"
                self.toId = dataSource.bbsComment[indexPath.section-1].publish_user_id
                self.toCommentID = dataSource.bbsComment[indexPath.section-1].comment_id!
                self.showInput()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BBSTopDetailCell") as! BBSTopDetailCell
            cell.titleLabel.numberOfLines = 0
            cell.detailLabel?.numberOfLines = 0
            cell.updateDetail(dataSource.bbsDetail!)
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCommentCell") as! BBSCommentCell
                cell.update(dataSource.bbsComment[indexPath.section-1])
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCommentChildCell") as! BBSCommentChildCell
                cell.update(dataSource.bbsComment[indexPath.section-1].children![indexPath.row-1])
                return cell
            }
        }
        
    }

}
