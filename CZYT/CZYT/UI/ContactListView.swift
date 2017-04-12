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
    func updateHiddenIds(_ hiddenIds:[String])
    {
        self.hiddenIds.removeAll()
        self.hiddenIds.append(contentsOf: hiddenIds)
        self.tableView.reloadData()
    }
    
    func update(_ tree:DepartmentTree)
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
                
                if nick.contains(text) || dep.contains(text) || mob.contains(text) || pinyin.contains(text.lowercased())
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
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
        self.addSubview(tableView)
    }
}

extension ContactListView : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if searchBar.isFirstResponder
        {
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        if selectMode == true
        {
            cell.accessoryType = .none
            if selectedIds.contains(user.id!)
            {
                cell.setChecked(false)
                selectedIds.remove(at: selectedIds.index(of: user.id!)!)
            }else{
                if selectedIds.count >= maxSelectCount
                {
                    MBProgressHUD.showMessag(self.showMaxCountText, to: self, showTimeSec: 1)
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
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        nav?.pushViewController(chat, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let user = dataSource[indexPath.row]
        if !showMySelf && user.id == UserInfo.sharedInstance.id || hiddenIds.contains(user.id!)
        {
            return 0
        }
        
        return ContactCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        cell.clipsToBounds = true
        let user = dataSource[indexPath.row]
        let showMobile = self.tree!.department!.isMyLevel()
        cell.updateUserInfo(user, showMobile: showMobile)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
    
        if selectMode == true
        {
            cell.accessoryType = .none
            cell.setChecked(selectedIds.contains(user.id!))
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension ContactListView : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.loadDataSource()
    }
}
