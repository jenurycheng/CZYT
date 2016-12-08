//
//  LeaderActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivityViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "时政新闻"
        // Do any additional setup after loading the view.
    }
    
    override func loadData()
    {
        if self.conditions.count == 0
        {
            lDataSource.getModelType(LeaderActivityDataSource.Type_LeaderActivity, success: { (result) in
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
        lDataSource.getLeaderActivity(true, classify: classify, success: { (result) in
            self.dataSource = self.lDataSource.leaderActivity
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
        lDataSource.getLeaderActivity(false, classify: classify, success: { (result) in
            self.dataSource = self.lDataSource.leaderActivity
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
        let detail = LeaderActivityDetailViewController(nibName: "LeaderActivityDetailViewController", bundle: nil)
        detail.id = lDataSource.leaderActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderActivityCell") as! LeaderActivityCell
        cell.update(lDataSource.leaderActivity[indexPath.row])
        return cell
    }
}
