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
        
        tableView.register(UINib(nibName: "PolicyFileCell", bundle: nil), forCellReuseIdentifier: "PolicyFileCell")
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
                
                if array.count > 0
                {
                    self.classify = array[0]
                }
                if self.dataSource.count == 0
                {
                    self.view.showHud()
                }
                self.lDataSource.getProjectWorkActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
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
            }) { (error) in
                
            }
        }else{
            if self.dataSource.count == 0
            {
                self.view.showHud()
            }
            self.lDataSource.getProjectWorkActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PolicyFileCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = ProjectWorkDetailViewController_New()
        detail.id = lDataSource.projectWorkActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyFileCell") as! PolicyFileCell
        cell.update(dataSource[indexPath.row])
        cell.scanLabel.text = "分类: " + (dataSource[indexPath.row].classify ?? "")
        return cell
    }
}
