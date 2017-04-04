//
//  BBSCommentViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/13.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSCommentViewController: BasePortraitViewController {

    var id:String?
    var dataSource = BBSDataSource()
    var tableView:UITableView!
    var commentBtn:UIButton!
    var isComment = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评论"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 170
        self.view.addSubview(tableView)
        tableView.registerNib(UINib(nibName: "BBSCommentCell", bundle: nil), forCellReuseIdentifier: "BBSCommentCell")
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf.loadData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf.loadMore()
        })
        
        commentBtn = UIButton(frame: CGRect(x: GetSWidth()-10-50, y: GetSHeight()-64-20-50, width: 50, height: 50))
        commentBtn.layer.cornerRadius = commentBtn.frame.height/2
        commentBtn.layer.masksToBounds = true
        commentBtn.setImage(UIImage(named: "comment_add"), forState: .Normal)
        commentBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        commentBtn.addTarget(self, action: #selector(BBSCommentViewController.commentBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(commentBtn)
        
        if isComment
        {
            self.commentBtnClicked()
        }
        
        self.loadData()
        // Do any additional setup after loading the view.
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
    
    func commentBtnClicked()
    {
        self.toId = nil
        KeyboardInputView.shareInstance().inputTextView.placeholder = "输入评论内容"
        self.showInput()
    }
    
    var toId:String?
    func showInput()
    {
        KeyboardInputView.shareInstance().show { (text) in
            self.comment(text)
        }
    }
    
    func comment(text:String)
    {
        if Helper.isStringEmpty(text)
        {
            MBProgressHUD.showMessag("内容不能为空", toView: self.view.window, showTimeSec: 1)
            return
        }
        self.view.showHud()
//        self.dataSource.addBBSComment(self.id!, content: text, userId: UserInfo.sharedInstance.id!, replyUserId: self.toId, success: { (result) in
//            self.view.dismiss()
//            KeyboardInputView.shareInstance().inputTextView.text = ""
//            KeyboardInputView.shareInstance().hide()
//            MBProgressHUD.showMessag("评论成功", toView: self.view, showTimeSec: 1)
//            
//            self.loadData()
//            }) { (error) in
//            self.view.dismiss()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BBSCommentViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bbsComment.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let toName = dataSource.bbsComment[indexPath.row].publish_user_name == nil ? "" : dataSource.bbsComment[indexPath.row].publish_user_name!
        KeyboardInputView.shareInstance().inputTextView.placeholder = "回复:\(toName)"
        self.toId = dataSource.bbsComment[indexPath.row].publish_user_id
        self.showInput()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BBSCommentCell") as! BBSCommentCell
        cell.update(dataSource.bbsComment[indexPath.row])
        return cell
    }
}
