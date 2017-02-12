//
//  BaseActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BaseActivityViewController: BasePortraitViewController {

    var searchBar:UISearchBar!
    var searchText:String = ""
    var conditionView:UIView!
    var tableView:UITableView!
    var provinceBtn:UIButton!
    var cityBtn:UIButton!
    var countryBtn:UIButton!
    var classify = ""
    var conditionBar:ConditionBar!
    var conditions = [String]()
    var dataSource = [LeaderActivity]()
    var conditionTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "领导活动"
        
        conditionView = UIView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: ConditionBar.barHeight()))
//        conditionView.backgroundColor = ThemeManager.current().backgroundColor
        self.view.addSubview(conditionView)
        conditionBar = ConditionBar(frame: conditionView.bounds)
        conditionBar.delegate = self
        conditionView.addSubview(conditionBar)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 40, width: GetSWidth(), height: 40))
        searchBar.delegate = self
        searchBar.placeholder = "输入搜索内容"
        self.view.addSubview(searchBar)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 80, width: GetSWidth(), height: GetSHeight()-64-80))
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
        
        self.loadData()
        
//        let searchItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(BaseActivityViewController.search))
//        self.navigationItem.rightBarButtonItem = searchItem
        // Do any additional setup after loading the view.
    }
    
    func search()
    {
        
    }
    
    var btns = [UIButton]()
    func setCondition(conditions:[String])
    {
        self.conditions = conditions
        self.conditionBar.loadView()
    }
    
    func btnClicked(btn:UIButton)
    {
        for b in btns
        {
            if !b.isEqual(btn)
            {
                b.selected = false
            }
        }
        btn.selected = !btn.selected
        classify = btn.selected ? btn.titleLabel!.text! : ""
        self.loadData()
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

extension BaseActivityViewController : ConditionBarDelegate
{
    func titleForConditionBar(conditionBar:ConditionBar)->String
    {
        return conditionTitle
    }
    
    func textsForConditionBar(conditionBar:ConditionBar)->[String]
    {
        return self.conditions
    }
    
    func selectedIndexForConditionBar(conditionBar:ConditionBar)->Int    //返回－1:全部
    {
        return -1
    }
    
    func didSelectedConditionBar(conditionBar:ConditionBar, index:Int)
    {
        if index == -1
        {
            self.classify = ""
        }else{
            self.classify = self.conditions[index]
        }
        self.loadData()
    }
}

extension BaseActivityViewController : UITableViewDelegate, UITableViewDataSource
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

extension BaseActivityViewController : UISearchBarDelegate
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
            self.loadData()
        }
    }
}
