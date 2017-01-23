//
//  ProjectWorkSearchViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/20.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ProjectWorkSearchViewController: BaseSearchViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重点项目"
        tableView.registerNib(UINib(nibName: "ProjectWorkCell", bundle: nil), forCellReuseIdentifier: "ProjectWorkCell")
        // Do any additional setup after loading the view.
    }

    override func loadData()
    {
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        lDataSource.getProjectWorkActivity(true, classify: "", key: self.searchText, success: { (result) in
            self.dataSource = self.lDataSource.projectWorkActivity
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
        lDataSource.getProjectWorkActivity(false, classify: "", key: self.searchText, success: { (result) in
            self.dataSource = self.lDataSource.projectWorkActivity
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ProjectWorkCell.cellHeight(dataSource[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = ProjectWorkDetailViewController()
        detail.id = lDataSource.projectWorkActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProjectWorkCell") as! ProjectWorkCell
        cell.update(dataSource[indexPath.row])
        return cell
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
