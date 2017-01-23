//
//  MyPublishTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MyPublishTaskViewController: BasePortraitViewController {

    var dataSource = TaskDataSource()
    var tableView:UITableView!
    
    static var shouldReload = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我发布的"
        MyPublishTaskViewController.shouldReload = true
        
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.registerNib(UINib(nibName: "MyTaskCell", bundle: nil), forCellReuseIdentifier: "MyTaskCell")
        self.view.addSubview(tableView)
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf.loadData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf.loadMore()
        })
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if MyPublishTaskViewController.shouldReload == true
        {
            super.viewWillAppear(animated)
            MyPublishTaskViewController.shouldReload = false
        }
        self.loadData()
    }
    
    func loadData()
    {
        if dataSource.publishTask.count == 0
        {
            self.view.showHud()
        }
        dataSource.getMyPublishTask(true, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.view.dismiss()
            }) { (error) in
                self.view.dismiss()
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    func loadMore()
    {
        dataSource.getMyPublishTask(false, success: { (result) in
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

extension MyPublishTaskViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.publishTask.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = TaskDetailViewController(nibName: "TaskDetailViewController", bundle: nil)
        detail.id = dataSource.publishTask[indexPath.row].task_id
        detail.isMyTask = false
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyTaskCell") as! MyTaskCell
        cell.selectionStyle = .None
        cell.updatePublish(dataSource.publishTask[indexPath.row])
        return cell
    }
}
