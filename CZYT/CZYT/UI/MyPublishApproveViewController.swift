//
//  MyPublishApproveViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/4/11.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class MyPublishApproveViewController: UIViewController {

    var tableView:UITableView!
    var dataSource = TaskDataSource()
    var id:String?
    var type:String?//类型，// 1代表重点项目,2代表动态消息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "批示列表"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        self.view.addSubview(tableView)
        tableView.register(UINib(nibName: "BBSCell_New", bundle: nil), forCellReuseIdentifier: "BBSCell_New")
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf.loadData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf.loadMore()
        })
        
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    
    static var needUpdate = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyPublishApproveViewController.needUpdate == true {
            self.loadData()
            MyPublishApproveViewController.needUpdate = false
        }
    }
    
    func loadData()
    {
        if dataSource.myPublishApproves.count == 0 {
            self.view.showHud()
        }
        dataSource.getMyPublishApprove(true, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.view.dismiss()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            self.view.dismiss()
        }
    }
    
    func loadMore()
    {
        dataSource.getMyPublishApprove(false, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            if result.count == 0
            {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        }) { (error) in
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyPublishApproveViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.myPublishApproves.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let type = dataSource.approves[indexPath.row].advice_type
        //        if type == "1"
        //        {
        //            let project = ProjectWorkDetailViewController_New()
        //            project.id = dataSource.approves[indexPath.row].advice_ref_id!
        //            project.hiddenItem = true
        //            self.navigationController?.pushViewController(project, animated: true)
        //        }else if type == "2"
        //        {
        //            let status = WorkStatusDetailViewController()
        //            status.id = dataSource.approves[indexPath.row].advice_ref_id!
        //            status.hiddenItem = true
        //            self.navigationController?.pushViewController(status, animated: true)
        //        }
        
        let detail = ApproveDetailViewController()
        detail.id = dataSource.myPublishApproves[indexPath.row].advice_id
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return BBSCell.cellHeight(dataSource.bbs[indexPath.row])
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCell_New") as! BBSCell_New
        cell.updateApprove(dataSource.myPublishApproves[indexPath.row])
        return cell
    }

}
