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
        self.conditionTitle = "推荐"
        
        self.tableView.registerNib(UINib(nibName: "TimeNewsCell", bundle: nil), forCellReuseIdentifier: "TimeNewsCell")
        // Do any additional setup after loading the view.
    }
    
    override func search()
    {
        let search = TimeNewsSearchViewController()
        self.navigationController?.pushViewController(search, animated: true)
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
//                array.insert("推荐", atIndex: 0)
                self.setCondition(array)
                if array.count > 0
                {
                    self.classify = array[0]
                }
                if self.dataSource.count == 0
                {
                    self.view.showHud()
                }
                self.lDataSource.getLeaderActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
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
            }) { (error) in
                
            }
        }else{
            if self.dataSource.count == 0
            {
                self.view.showHud()
            }
            self.lDataSource.getLeaderActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
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
        
    }
    
    override func loadMore()
    {
        lDataSource.getLeaderActivity(false, classify: classify, key: self.searchText, success: { (result) in
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TimeNewsCell.cellHeight(lDataSource.leaderActivity[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeNewsCell") as! TimeNewsCell
        cell.update(lDataSource.leaderActivity[indexPath.row])
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = TimeNewsDetailViewController()
        detail.id = lDataSource.leaderActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
}
