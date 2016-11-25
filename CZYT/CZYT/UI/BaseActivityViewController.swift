//
//  BaseActivityViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BaseActivityViewController: BasePortraitViewController {

    var conditionView:UIView!
    var tableView:UITableView!
    var provinceBtn:UIButton!
    var cityBtn:UIButton!
    var countryBtn:UIButton!
    var classify = ""
    
    var dataSource = [LeaderActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "领导活动"
        
        conditionView = UIView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: 40))
        conditionView.backgroundColor = ThemeManager.current().backgroundColor
        self.view.addSubview(conditionView)
        
        
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
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    var btns = [UIButton]()
    func setCondition(conditions:[String])
    {
        let width = (GetSWidth()-5)/CGFloat(conditions.count)
        for i in 0 ..< conditions.count
        {
            let btn = UIButton(frame: CGRect(x: width*CGFloat(i) + 5, y: 5, width: width-5, height: 30))
            btn.setTitle(conditions[i], forState: .Normal)
            btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            btn.setBackgroundImage(Helper.imageWithColor(UIColor.whiteColor(), size: CGSizeMake(10, 10)), forState: .Normal)
            btn.setBackgroundImage(Helper.imageWithColor(ThemeManager.current().mainColor, size: CGSizeMake(10, 10)), forState: .Selected)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            conditionView.addSubview(btn)
            btn.addTarget(self, action: #selector(BaseActivityViewController.btnClicked(_:)), forControlEvents: .TouchUpInside)
            btns.append(btn)
        }
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

extension BaseActivityViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return LeaderActivityCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeaderActivityCell") as! LeaderActivityCell
        cell.update(dataSource[indexPath.row])
        return cell
    }
}
