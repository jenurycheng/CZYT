//
//  BBSCommentViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/13.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSCommentViewController: BasePortraitViewController {

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
        self.view.addSubview(tableView)
        tableView.registerNib(UINib(nibName: "BBSCommentCell", bundle: nil), forCellReuseIdentifier: "BBSCommentCell")
        
        commentBtn = UIButton(frame: CGRect(x: GetSWidth()-10-50, y: GetSHeight()-64-20-50, width: 50, height: 50))
        commentBtn.layer.cornerRadius = commentBtn.frame.height/2
        commentBtn.layer.masksToBounds = true
        commentBtn.backgroundColor = ThemeManager.current().mainColor
        commentBtn.setTitle("写评论", forState: .Normal)
        commentBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        commentBtn.addTarget(self, action: #selector(BBSCommentViewController.commentBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(commentBtn)
        
        if isComment
        {
            self.commentBtnClicked()
        }
        // Do any additional setup after loading the view.
    }
    
    func commentBtnClicked()
    {
        KeyboardInputView.shareInstance().show { (text) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BBSCommentViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = BBSDetailViewController(nibName: "BBSDetailViewController", bundle: nil)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BBSCommentCell") as! BBSCommentCell
        return cell
    }
}
