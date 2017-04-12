//
//  ApproveListViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/4/4.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ApproveListViewController: BasePortraitViewController {

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
        tableView.register(UINib(nibName: "BBSCommentCell", bundle: nil), forCellReuseIdentifier: "BBSCommentCell")
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf.loadData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf.loadMore()
        })
        
        self.loadData()
        
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ApproveListViewController.addClicked))
        self.navigationItem.rightBarButtonItem = add
        // Do any additional setup after loading the view.
    }
    
    static var needUpdate = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ApproveListViewController.needUpdate == true {
            self.loadData()
            ApproveListViewController.needUpdate = false
        }
    }
    
    func addClicked()
    {
        let publish = PublishApproveViewController(nibName: "PublishApproveViewController", bundle: nil)
        publish.id = self.id
        publish.type = self.type
        self.navigationController?.pushViewController(publish, animated: true)
        
    }
    
    func loadData()
    {
        if dataSource.approves.count == 0 {
            self.view.showHud()
        }
        dataSource.getApprove(true, advice_type: self.type, advice_ref_id: self.id!, success: { (result) in
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
        dataSource.getApprove(false, advice_type: self.type, advice_ref_id: self.id!, success: { (result) in
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

extension ApproveListViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.approves.count
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        return BBSCell.cellHeight(dataSource.bbs[indexPath.row])
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCommentCell") as! BBSCommentCell
        cell.updateApprove(dataSource.approves[indexPath.row])
        return cell
    }
}
