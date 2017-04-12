//
//  ProjectItemCell3.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/28.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class ProjectItemCell3: UITableViewCell {

    @IBOutlet weak var label1:UILabel!
    @IBOutlet weak var label2:UILabel!
    @IBOutlet weak var label3:UILabel!
    @IBOutlet weak var label4:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        label1.textColor = ThemeManager.current().darkGrayFontColor
        label1.font = UIFont.systemFont(ofSize: 14)
        
        label2.textColor = ThemeManager.current().grayFontColor
        label2.font = UIFont.systemFont(ofSize: 13)
        
        label3.textColor = ThemeManager.current().darkGrayFontColor
        label3.font = UIFont.systemFont(ofSize: 14)
        
        label4.textColor = ThemeManager.current().grayFontColor
        label4.font = UIFont.systemFont(ofSize: 13)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
