//
//  ProjectWorkActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ProjectWorkActivityViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重点项目"
        
        tableView.registerNib(UINib(nibName: "PolicyFileCell", bundle: nil), forCellReuseIdentifier: "PolicyFileCell")
        // Do any additional setup after loading the view.
    }
    
    override func search() {
        let search = ProjectWorkSearchViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func loadData()
    {
        if self.conditions.count == 0
        {
            lDataSource.getModelType(LeaderActivityDataSource.Type_ProjectWork, success: { (result) in
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
        lDataSource.getProjectWorkActivity(true, classify: classify, key: self.searchText, success: { (result) in
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
        lDataSource.getProjectWorkActivity(false, classify: classify, key: self.searchText, success: { (result) in
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
        return PolicyFileCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = ProjectWorkDetailViewController()
        detail.id = lDataSource.projectWorkActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PolicyFileCell") as! PolicyFileCell
        cell.update(dataSource[indexPath.row])
        cell.scanLabel.text = "来源: " + (dataSource[indexPath.row].classify ?? "")
        return cell
    }
}
