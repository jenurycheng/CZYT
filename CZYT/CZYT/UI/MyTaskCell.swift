//
//  MyTaskCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MyTaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var publishManLabel:UILabel!
    @IBOutlet weak var publishTimeLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateMy(_ task:Task)
    {
        self.update(task)
        
        if !Helper.isStringEmpty(task.task_assigner_user_name)
        {
            let name = task.task_assigner_user_name == nil ? "" : task.task_assigner_user_name!
            publishManLabel.text = "指派人: " + name
        }else{
            let name = task.task_publish_user_name == nil ? "" : task.task_publish_user_name!
            publishManLabel.text = "发布人: " + name
        }
    }
    
    func updatePublish(_ task:Task)
    {
        self.update(task)
        
        var name = "指派给: "
        if task.assignees != nil
        {
            if task.assignees!.count > 0
            {
                let n = task.assignees![0].assignee_user_name == nil ? "" : task.assignees![0].assignee_user_name!
                name = name  + n
            }
            if task.assignees?.count > 1
            {
//                let n = task.assignees![1].assignee_user_name == nil ? "" : task.assignees![1].assignee_user_name!
//                name = name + ", " + n
                name = name + " 等\(task.assignees!.count)人"
            }
        }
        publishManLabel.text = name
    }
    
    func update(_ task:Task)
    {
//        titleLabel.text = task.task_title
        contentLabel.text = task.task_content
        statusLabel.text = task.task_status_name
        
        if task.task_publish_date != nil
        {
            publishTimeLabel.text = "指派时间:" + task.task_publish_date!
        }

        if task.task_status! == "responsing"//待接受
        {
            if task.task_end_date != nil
            {
                timeLabel.text = "截止时间:" + Helper.formatDateString(task.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
            }
        }else if task.task_status! == "finished"//已完成
        {
//            if task.task_finish_date != nil
//            {
//                timeLabel.text = "完成时间:" + Helper.formatDateString(task.task_finish_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
//            }
            if task.task_end_date != nil
            {
                timeLabel.text = "截止时间:" + Helper.formatDateString(task.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
            }
        }else if task.task_status! == "accepted"//已接受
        {
//            if task.task_accept_date != nil
//            {
//                timeLabel.text = "接受时间:" + Helper.formatDateString(task.task_accept_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
//            }
            if task.task_end_date != nil
            {
                timeLabel.text = "截止时间:" + Helper.formatDateString(task.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
