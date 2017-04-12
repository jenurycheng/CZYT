//
//  FileActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class FileActivityViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "政策文件"
        
        tableView.register(UINib(nibName: "PolicyFileCell", bundle: nil), forCellReuseIdentifier: "PolicyFileCell")
        // Do any additional setup after loading the view.
    }
    
    override func search() {
        let search = PolicyFileSearchViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    override func loadData()
    {
        if self.conditions.count == 0
        {
            lDataSource.getModelType(LeaderActivityDataSource.Type_PolicyFile, success: { (result) in
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
                self.lDataSource.getFileActivity(true, classify: self.classify, key: self.searchText, success: { (result) in
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
            }) { (error) in
                
            }
        }else{
            if self.dataSource.count == 0
            {
                self.view.showHud()
            }
            lDataSource.getFileActivity(true, classify: classify, key: self.searchText, success: { (result) in
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
    }
    
    override func loadMore()
    {
        lDataSource.getLeaderActivity(false, classify: classify, key: self.searchText, success: { (result) in
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PolicyFileCell.cellHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PolicyFileCell") as! PolicyFileCell
        cell.update(lDataSource.fileActivity[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
