//
//  BBSViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSViewController: BasePortraitViewController {

    var tableView:UITableView!
    var dataSource = BBSDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "他山之石"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        tableView.registerNib(UINib(nibName: "BBSCell", bundle: nil), forCellReuseIdentifier: "BBSCell")
        
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
    
    func loadData()
    {
        if dataSource.bbs.count == 0 {
            self.view.showHud()
        }
        dataSource.getBBSList(true, success: { (result) in
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
        dataSource.getBBSList(false, success: { (result) in
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

extension BBSViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bbs.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detail = BBSDetailViewController(nibName: "BBSDetailViewController", bundle: nil)
        detail.id = dataSource.bbs[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return BBSCell.cellHeight(dataSource.bbs[indexPath.row])
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BBSCell") as! BBSCell
        cell.update(dataSource.bbs[indexPath.row])
        return cell
    }
}

