//
//  MyTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MyTaskViewController: BasePortraitViewController {

    static var shouldReload = true
    var dataSource = TaskDataSource()
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的任务"
        MyTaskViewController.shouldReload = true
        
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(UINib(nibName: "MyTaskCell", bundle: nil), forCellReuseIdentifier: "MyTaskCell")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if MyTaskViewController.shouldReload == true
        {
            self.loadData()
            MyTaskViewController.shouldReload = false
        }
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
            self.tableView.mj_footer.endRefreshing()
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

extension MyTaskViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.myTask.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = TaskDetailViewController(nibName: "TaskDetailViewController", bundle: nil)
        detail.id = dataSource.myTask[indexPath.row].task_id
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTaskCell") as! MyTaskCell
        cell.selectionStyle = .none
        cell.updateMy(dataSource.myTask[indexPath.row])
        return cell
    }
}
