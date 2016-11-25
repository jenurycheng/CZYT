//
//  MyTaskCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

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
    
    func updateMy(task:Task)
    {
        self.update(task)
    }
    
    func updatePublish(task:Task)
    {
        self.update(task)
    }
    
    func update(task:Task)
    {
        titleLabel.text = task.task_title
        contentLabel.text = task.task_content
        statusLabel.text = task.task_status_name
//        publishTimeLabel.text = task.task_
        
        if task.task_end_date != nil
        {
            timeLabel.text = "截止时间:" + Helper.formatDateString(task.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
