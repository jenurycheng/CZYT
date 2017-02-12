//
//  TaskNotifyViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/22.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TaskNotifyViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    var tDataSource = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知通报"
    }
    
    override func search()
    {
        let search = TaskNotifySearchViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func loadData()
    {
        if self.conditions.count == 0
        {
            lDataSource.getModelType(LeaderActivityDataSource.Type_TaskNotify, success: { (result) in
                var array = [String]()
                for r in result
                {
                    array.append(r.value!)
                }
                self.setCondition(array)
            }) { (error) in
                
            }
        }
        
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        tDataSource.getTaskNotify(true, key: self.searchText, classify: classify, success: { (result) in
            self.dataSource = self.tDataSource.notify
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            self.view.dismiss()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.view.dismiss()
            NetworkErrorView.show(self.view, data: error, callback: {
                self.loadData()
            })
        }
    }
    
    override func loadMore()
    {
        tDataSource.getTaskNotify(false, key: self.searchText, classify: classify, success: { (result) in
            self.dataSource = self.tDataSource.notify
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            if result.count == 0
            {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
            self.view.dismiss()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = TaskNotifyDetailViewController()
        detail.id = tDataSource.notify[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }

}