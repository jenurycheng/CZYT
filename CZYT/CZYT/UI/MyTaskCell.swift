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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(task:Task)
    {
        titleLabel.text = task.task_title
        contentLabel.text = task.task_content
        statusLabel.text = task.task_status_name
        timeLabel.text = task.task_end_date
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
