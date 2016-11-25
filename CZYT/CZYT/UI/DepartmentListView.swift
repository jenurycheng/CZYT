//
//  DepartmentListView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol DepartmentListViewDelegate : NSObjectProtocol {
    func departmentTreeSelected(depart:DepartmentTree)
}

class DepartmentListView: UIView {

    var tableView:UITableView!
    weak var delegate:DepartmentListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update()
    {
        self.tableView.reloadData()
    }
    
    func initView()
    {
        tableView = UITableView(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        self.addSubview(tableView)
    }
}

extension DepartmentListView : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DepartmentTree.allSubTree.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate?.departmentTreeSelected(DepartmentTree.allSubTree[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let tree = DepartmentTree.allSubTree[indexPath.row]
        
        let nameLabel = UILabel(frame: CGRect(x: 5 + 20 * CGFloat(tree.level), y: 0, width: self.frame.width, height: 40))
        nameLabel.font = UIFont.systemFontOfSize(14)
        nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        nameLabel.text = tree.department?.dept_name
        cell.addSubview(nameLabel)
        
        let numLabel = UILabel(frame: CGRect(x: CCSideView.LeftWidth-50, y: 0, width: 40, height: 40))
        numLabel.font = UIFont.systemFontOfSize(13)
        numLabel.textAlignment = .Right
        numLabel.textColor = ThemeManager.current().grayFontColor
        numLabel.text = "\(tree.users.count)"
        cell.addSubview(numLabel)
        
        let line = GetLineView(CGRect(x: 5, y: 39, width: GetSWidth()-5, height: 1))
        cell.addSubview(line)
        
        return cell
    }
}
