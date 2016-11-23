//
//  MyTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MyTaskViewController: BasePortraitViewController {

    var dataSource = TaskDataSource()
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
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
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    func loadData()
    {
        if dataSource.myTask.count == 0
        {
            self.view.showHud()
        }
        dataSource.getMyTask(true, success: { (result) in
            self.view.dismiss()
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            }) { (error) in
                self.view.dismiss()
                self.tableView.mj_header.endRefreshing()
        }
    }
    
    func loadMore()
    {
        dataSource.getMyTask(false, success: { (result) in
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            }) { (error) in
            self.tableView.mj_footer.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyTaskViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.myTask.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let image1 = UIImage(named: "test")
//        let image2 = UIImage(named: "user_header_bg")
//        dataSource.finishTask(dataSource.myTask[indexPath.row].task_id!, text: "我完成了任务", photos: [image1!, image2!], success: { (result) in
//            MBProgressHUD.showMessag("成功", toView: self.view, showTimeSec: 1)
//            }) { (error) in
//                MBProgressHUD.showMessag(error.msg, toView: self.view, showTimeSec: 1)
//        }
        let detail = TaskDetailViewController(nibName: "TaskDetailViewController", bundle: nil)
        detail.id = dataSource.myTask[indexPath.row].task_id
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyTaskCell") as! MyTaskCell
        cell.update(dataSource.myTask[indexPath.row])
        return cell
    }
}
