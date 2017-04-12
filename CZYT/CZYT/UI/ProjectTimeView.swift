//
//  ProjectTimeView.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/28.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ProjectTimeView: UIView {

    var tableView:UITableView!
    var times = [String?]()
    var shows = [String?]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        self.backgroundColor = ThemeManager.current().foregroundColor
        
        tableView = UITableView(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        self.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProjectItemTimeCell", bundle: nil), forCellReuseIdentifier: "ProjectItemTimeCell")
    }
    
    func update(_ data:ProjectWorkDetail?)
    {
        if data == nil {
            return
        }
        times.removeAll()
        shows.removeAll()
        
        times.append(data!.projectwork_promotion_m1)
        times.append(data!.projectwork_promotion_m2)
        times.append(data!.projectwork_promotion_m3)
        times.append(data!.projectwork_promotion_m4)
        times.append(data!.projectwork_promotion_m5)
        times.append(data!.projectwork_promotion_m6)
        times.append(data!.projectwork_promotion_m7)
        times.append(data!.projectwork_promotion_m8)
        times.append(data!.projectwork_promotion_m9)
        times.append(data!.projectwork_promotion_m10)
        times.append(data!.projectwork_promotion_m11)
        times.append(data!.projectwork_promotion_m12)
        
        shows.append(data!.projectwork_promotion_m1_isshow)
        shows.append(data!.projectwork_promotion_m2_isshow)
        shows.append(data!.projectwork_promotion_m3_isshow)
        shows.append(data!.projectwork_promotion_m4_isshow)
        shows.append(data!.projectwork_promotion_m5_isshow)
        shows.append(data!.projectwork_promotion_m6_isshow)
        shows.append(data!.projectwork_promotion_m7_isshow)
        shows.append(data!.projectwork_promotion_m8_isshow)
        shows.append(data!.projectwork_promotion_m9_isshow)
        shows.append(data!.projectwork_promotion_m10_isshow)
        shows.append(data!.projectwork_promotion_m11_isshow)
        shows.append(data!.projectwork_promotion_m12_isshow)
        
        tableView.reloadData()
    }
}

extension ProjectTimeView : UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shows[indexPath.row] == nil || shows[indexPath.row]! != "1" {
            return 0
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectItemTimeCell") as! ProjectItemTimeCell
        cell.label1.text = "\(indexPath.row + 1)" + "月份"
        cell.label2.text = times[indexPath.row]
        return cell
    }
}
