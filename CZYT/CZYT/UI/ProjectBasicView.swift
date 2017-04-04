//
//  ProjectBasicView.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/28.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ProjectBasicView: UIView {

    var tableView:UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var data:ProjectWorkDetail?
    func update(data:ProjectWorkDetail?)
    {
        self.data = data
        tableView.reloadData()
    }
    
    func initView()
    {
        self.backgroundColor = ThemeManager.current().foregroundColor
        
        tableView = UITableView(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .None
        
        tableView.registerNib(UINib(nibName: "ProjectItemCell1", bundle: nil), forCellReuseIdentifier: "ProjectItemCell1")
        tableView.registerNib(UINib(nibName: "ProjectItemCell1", bundle: nil), forCellReuseIdentifier: "ProjectItemCell1")
        tableView.registerNib(UINib(nibName: "ProjectItemCell3", bundle: nil), forCellReuseIdentifier: "ProjectItemCell3")
        
        self.addSubview(tableView)
    }
}

extension ProjectBasicView : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell1") as! ProjectItemCell1
            cell.label1.text = "主要合作内容或建设规模"
            cell.label2.text = data?.projectwork_basic_content
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell1") as! ProjectItemCell1
            cell.label1.text = "计划年限"
            cell.label2.text = data?.projectwork_basic_plan_age_limit
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell1") as! ProjectItemCell1
            cell.label1.text = "2017年要达到的主要形象进度"
            cell.label2.text = data?.projectwork_basic_image_progress
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell3") as! ProjectItemCell3
            cell.label1.text = "资阳牵头单位"
            cell.label2.text = data?.projectwork_basic_ziyang_qiantou_unit
            cell.label3.text = "责任人"
            cell.label4.text = data?.projectwork_basic_ziyang_zerenren
            return cell
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell1") as! ProjectItemCell1
            cell.label1.text = "资阳责任单位"
            cell.label2.text = data?.projectwork_basic_ziyang_zeren_unit
            return cell
        }else if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell3") as! ProjectItemCell3
            cell.label1.text = "成都牵头单位"
            cell.label2.text = data?.projectwork_basic_chengdu_qiantou_unit
            cell.label3.text = "责任人"
            cell.label4.text = data?.projectwork_basic_chengdu_zerenren
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProjectItemCell1") as! ProjectItemCell1
            cell.label1.text = "成都责任单位"
            cell.label2.text = data?.projectwork_basic_chengdu_zeren_unit
            return cell
        }
    }
}
