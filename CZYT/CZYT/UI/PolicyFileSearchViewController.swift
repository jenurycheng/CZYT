//
//  PolicyFileSearchViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/20.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class PolicyFileSearchViewController: BaseSearchViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "政策文件"
        // Do any additional setup after loading the view.
    }

    override func loadData()
    {
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        lDataSource.getFileActivity(true, classify: "", key: self.searchText, success: { (result) in
            self.dataSource = self.lDataSource.fileActivity
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
        lDataSource.getLeaderActivity(false, classify: "", key: self.searchText, success: { (result) in
            self.dataSource = self.lDataSource.fileActivity
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
        let detail = PolicyFileDetailViewController()
        detail.id = lDataSource.fileActivity[indexPath.row].id!
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
