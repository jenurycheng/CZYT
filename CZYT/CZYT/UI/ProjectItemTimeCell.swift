//
//  ProjectItemTimeCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/28.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ProjectItemTimeCell: UITableViewCell {

    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        label1.textColor = ThemeManager.current().darkGrayFontColor
        label1.font = UIFont.systemFontOfSize(14)
        
        label2.textColor = ThemeManager.current().grayFontColor
        label2.font = UIFont.systemFontOfSize(13)
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
