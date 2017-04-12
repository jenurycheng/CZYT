//
//  TimeNewsSearchViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/18.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TimeNewsSearchViewController: BaseSearchViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "时政新闻"
        self.tableView.register(UINib(nibName: "TimeNewsCell", bundle: nil), forCellReuseIdentifier: "TimeNewsCell")
        // Do any additional setup after loading the view.
    }
    
    override func loadData()
    {
        
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        
        lDataSource.getLeaderActivity(true, classify: "", key: self.searchText, success: { (result) in
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
        lDataSource.getLeaderActivity(false, classify: "", key: self.searchText, success: { (result) in
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TimeNewsCell.cellHeight(lDataSource.leaderActivity[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeNewsCell") as! TimeNewsCell
        cell.update(lDataSource.leaderActivity[indexPath.row])
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = TimeNewsDetailViewController()
        detail.id = lDataSource.leaderActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
