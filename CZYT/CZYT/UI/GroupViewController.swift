//
//  GroupViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class GroupViewController: BasePortraitViewController {

    var dataSource = ChatDataSource.sharedInstance
    
    var tableView:UITableView!
    var addGroupBtn:UIButton!
    var bbsBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.registerNib(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        tableView.registerNib(UINib(nibName: "ChatGroupTopCell", bundle: nil), forCellReuseIdentifier: "ChatGroupTopCell")
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf.loadData()
        })
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        dataSource.queryUserGroup(UserInfo.sharedInstance.id!, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            }) { (error) in
            self.tableView.mj_header.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GroupViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 20
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }else{
            let v = UIView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: 20))
            v.backgroundColor = ThemeManager.current().backgroundColor
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: GetSWidth()-10, height: 20))
            label.text = "我加入的群"
            label.font = UIFont.systemFontOfSize(12)
            label.textColor = ThemeManager.current().grayFontColor
            v.addSubview(label)
            return v
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 1
        }
        return dataSource.group.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1
        {
            let chat = GroupConversationViewController()
            chat.conversationType = RCConversationType.ConversationType_GROUP
            chat.targetId = dataSource.group[indexPath.row].groupId
            chat.title = dataSource.group[indexPath.row].groupName
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else{
            return 50
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatGroupTopCell") as! ChatGroupTopCell
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("ChatGroupCell") as! ChatGroupCell
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            cell.update(dataSource.group[indexPath.row])
            return cell
        }
    }
}
