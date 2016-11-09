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
        self.title = "领导活动"
        
        // Do any additional setup after loading the view.
    }
    
    override func loadData()
    {
        self.view.showHud()
        lDataSource.getProjectWorkActivity(true, success: { (result) in
            self.dataSource = self.lDataSource.projectWorkActivity
            self.tableView.mj_header.endRefreshing()
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
        lDataSource.getProjectWorkActivity(false, success: { (result) in
            self.dataSource = self.lDataSource.projectWorkActivity
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            self.view.dismiss()
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
        let detail = ProjectWorkActivityDetailViewController(nibName: "ProjectWorkActivityDetailViewController", bundle: nil)
        detail.id = lDataSource.projectWorkActivity[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
