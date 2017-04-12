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

        self.title = "建言献策"
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        self.view.addSubview(tableView)
        tableView.register(UINib(nibName: "BBSCell", bundle: nil), forCellReuseIdentifier: "BBSCell")
        tableView.register(UINib(nibName: "BBSCell_New", bundle: nil), forCellReuseIdentifier: "BBSCell_New")
        
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf.loadData()
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { 
            weakSelf.loadMore()
        })
        
        self.loadData()
        
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(BBSViewController.addClicked))
        self.navigationItem.rightBarButtonItem = add
        // Do any additional setup after loading the view.
    }
    
    func addClicked()
    {
        let add = PublishBBSViewController(nibName: "PublishBBSViewController", bundle: nil)
        self.navigationController?.pushViewController(add, animated: true)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.bbs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let detail = BBSDetailViewController(nibName: "BBSDetailViewController", bundle: nil)
//        detail.id = dataSource.bbs[indexPath.row].id!
//        self.navigationController?.pushViewController(detail, animated: true)
        let detail = BBSDetailViewController_New()
        detail.id = dataSource.bbs[indexPath.row].id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return BBSCell.cellHeight(dataSource.bbs[indexPath.row])
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBSCell_New") as! BBSCell_New
        cell.titleLabel.numberOfLines = 0
        cell.update(dataSource.bbs[indexPath.row])
        return cell
    }
}

