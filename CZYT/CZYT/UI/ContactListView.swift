//
//  ContactListView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol ContentListViewDelegate : NSObjectProtocol {
    func contentListSelectedIdsChanged()
}

class ContactListView: UIView {

    var showMySelf = false  //是否显示自己
    var showMaxCountText:String = "超过人数"    //选择人数超过指定人数时提示信息
    var maxSelectCount = 100000     //最大选择人数
    var selectMode = false      //选择模式
    var selectedIds = [String]()
    
    var delegate:ContentListViewDelegate?
    var searchBar:UISearchBar!
    
    var originalDataSource = [UserInfo]()
    var dataSource = [UserInfo]()
    var tableView:UITableView!
    var tree:DepartmentTree?
    init(frame: CGRect, selectMode:Bool = false) {
        super.init(frame: frame)
        self.selectMode = selectMode
        self.initView()
    }
    
    var hiddenIds = [String]()
    func updateHiddenIds(hiddenIds:[String])
    {
        self.hiddenIds.removeAll()
        self.hiddenIds.appendContentsOf(hiddenIds)
        self.tableView.reloadData()
    }
    
    func update(tree:DepartmentTree)
    {
        self.tree = tree
        originalDataSource = tree.users
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
                let pinyin = u.pinyin == nil ? "" : u.pinyin!
                let mob = u.mobile
                
                if nick.contain(subStr: text) || dep.contain(subStr: text) || mob.contain(subStr: text) || pinyin.contain(subStr: text.lowercaseString)
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
        tableView.registerNib(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.addSubview(tableView)
    }
}

extension ContactListView : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        if searchBar.isFirstResponder()
        {
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let user = dataSource[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ContactCell
        if selectMode == true
        {
            cell.accessoryType = .None
            if selectedIds.contains(user.id!)
            {
                cell.setChecked(false)
                selectedIds.removeAtIndex(selectedIds.indexOf(user.id!)!)
            }else{
                if selectedIds.count >= maxSelectCount
                {
                    MBProgressHUD.showMessag(self.showMaxCountText, toView: self, showTimeSec: 1)
                }else{
                    cell.setChecked(true)
                    selectedIds.append(user.id!)
                }
            }
            if delegate != nil {
                delegate?.contentListSelectedIdsChanged()
            }
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
        
        let user = dataSource[indexPath.row]
        if !showMySelf && user.id == UserInfo.sharedInstance.id || hiddenIds.contains(user.id!)
        {
            return 0
        }
        
        return ContactCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        cell.clipsToBounds = true
        let user = dataSource[indexPath.row]
        let showMobile = self.tree!.department!.isMyLevel()
        cell.updateUserInfo(user, showMobile: showMobile)
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
    
        if selectMode == true
        {
            cell.accessoryType = .None
            cell.setChecked(selectedIds.contains(user.id!))
        }
        
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
