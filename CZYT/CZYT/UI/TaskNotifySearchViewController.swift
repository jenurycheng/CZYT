//
//  TaskNotifySearchViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/22.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TaskNotifySearchViewController: BaseSearchViewController {

    var lDataSource = LeaderActivityDataSource()
    var tDataSource = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知通报"
    }
    
    override func loadData()
    {
        
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        tDataSource.getTaskNotify(true, key:self.searchText, classify: "", success: { (result) in
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
        tDataSource.getTaskNotify(false, key:self.searchText, classify: "", success: { (result) in
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = TaskNotifyDetailViewController()
        detail.id = tDataSource.notify[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
