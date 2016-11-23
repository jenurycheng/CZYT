//
//  ContactListView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ContactListView: UIView {

    var searchBar:UISearchBar!
    
    var originalDataSource = ContactDataSource.sharedInstance.getUser(UserInfo.sharedInstance.dept_id!)
    var dataSource = [UserInfo]()
    var tableView:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    func update(departId:String)
    {
        originalDataSource = ContactDataSource.sharedInstance.getUser(departId)
        self.loadDataSource()
    }
    
    func loadDataSource()
    {
        dataSource.removeAll()
        for u in originalDataSource {
            if !Helper.isStringEmpty(searchBar.text)  {
                let text = searchBar.text!
                let nick = u.nickname == nil ? "" : u.nickname!
                let dep = u.dept_name == nil ? "" : u.dept_name!
                let mob = u.mobile
                
                if nick.contain(subStr: text) || dep.contain(subStr: text) || mob.contain(subStr: text)
                {
                    dataSource.append(u)
                }
            }else{
                dataSource.append(u)
            }
        }
        
        self.tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
        searchBar.delegate = self
        self.addSubview(searchBar)
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: self.frame.width, height: self.frame.height-40))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "ChatGroupCell", bundle: nil), forCellReuseIdentifier: "ChatGroupCell")
        self.addSubview(tableView)
    }
}

extension ContactListView : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if dataSource[indexPath.row].id == UserInfo.sharedInstance.id
        {
            return
        }
        let chat = PrivateConversationViewController()
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        chat.targetId = dataSource[indexPath.row].id
        chat.title = dataSource[indexPath.row].nickname
        let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
        nav?.pushViewController(chat, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ChatGroupCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatGroupCell") as! ChatGroupCell
        cell.updateUserInfo(dataSource[indexPath.row])
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension ContactListView : UISearchBarDelegate
{
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadDataSource()
    }
}
