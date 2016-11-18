//
//  DepartmentListView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol DepartmentListViewDelegate : NSObjectProtocol {
    func departmentSelected(depart:Department)
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
        self.addSubview(tableView)
    }
}

extension DepartmentListView : UITableViewDataSource, UITableViewDelegate
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DepartmentTree.allSubDepartment.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate?.departmentSelected(DepartmentTree.allSubDepartment[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = DepartmentTree.allSubDepartment[indexPath.row].dept_name
        return cell
    }
}
