//
//  WorkStatusActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class WorkStatusActivityViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动态消息"
//        self.conditionBar.hidden = true
//        tableView.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64)
        // Do any additional setup after loading the view.
    }
    
    override func search()
    {
        let search = WorkStatusSearchViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func loadData()
    {
        if self.conditions.count == 0
        {
            lDataSource.getModelType(LeaderActivityDataSource.Type_WorkStatus, success: { (result) in
                var array = [String]()
                for r in result
                {
                    array.append(r.value!)
                }
                self.setCondition(array)
                
                if array.count > 0
                {
                    self.classify = array[0]
                }
                if self.dataSource.count == 0
                {
                    self.view.showHud()
                }
                self.lDataSource.getWorkStatusActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
                    self.dataSource = self.lDataSource.workStatusActivity
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
            self.lDataSource.getWorkStatusActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
                self.dataSource = self.lDataSource.workStatusActivity
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
        lDataSource.getWorkStatusActivity(false, classify: classify, key: self.searchText, success: { (result) in
            self.dataSource = self.lDataSource.workStatusActivity
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
        let detail = WorkStatusDetailViewController()
        detail.id = lDataSource.workStatusActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
