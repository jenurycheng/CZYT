//
//  DepartStatusActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/7.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class DepartStatusActivityViewController: BaseActivityViewController {

    var lDataSource = LeaderActivityDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门动态"
        
        self.conditionView.hidden = true
        tableView.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64)
        // Do any additional setup after loading the view.
    }
    
    override func loadData()
    {
        if self.dataSource.count == 0
        {
            self.view.showHud()
        }
        lDataSource.getDepartStatusActivity(true, success: { (result) in
            self.dataSource = self.lDataSource.departStatusActivity
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
        lDataSource.getDepartStatusActivity(false, success: { (result) in
            self.dataSource = self.lDataSource.departStatusActivity
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
        let detail = DepartStatusDetailViewController()
        detail.id = lDataSource.departStatusActivity[indexPath.row].id!
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
