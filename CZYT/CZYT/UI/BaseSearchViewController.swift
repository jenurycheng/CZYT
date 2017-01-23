//
//  BaseSearchViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/18.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class BaseSearchViewController: BasePortraitViewController {

    var searchBar:UISearchBar!
    var searchText:String = ""
    var tableView:UITableView!
    var dataSource = [LeaderActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: 40))
        searchBar.delegate = self
        searchBar.placeholder = "输入搜索内容"
        self.view.addSubview(searchBar)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 40, width: GetSWidth(), height: GetSHeight()-64-40))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "LeaderActivityCell", bundle: nil), forCellReuseIdentifier: "LeaderActivityCell")
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        unowned let weakSelf = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            weakSelf.loadData()
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf.loadMore()
        })
        self.searchBar.becomeFirstResponder()
//        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        
    }
    
    func loadMore()
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseSearchViewController : UITableViewDelegate, UITableViewDataSource
{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LeaderActivityCell.cellHeight(dataSource[indexPath.row])
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderActivityCell") as! LeaderActivityCell
        cell.update(dataSource[indexPath.row])
        return cell
    }
}

extension BaseSearchViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchBar.text != nil
        {
            self.searchText = searchBar.text!
        }else{
            self.searchText = ""
        }
        self.loadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchText = searchText
        if searchText == ""
        {
            self.searchText = ""
//            self.loadData()
        }
    }
}