//
//  PolicyFileCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/2/19.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class PolicyFileCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentBgView:UIView!
    @IBOutlet weak var scanLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = ThemeManager.current().backgroundColor
        self.selectionStyle = .None
        
        contentBgView.layer.cornerRadius = 5
        contentBgView.layer.masksToBounds = true

        titleLabel.textColor = ThemeManager.current().darkGrayFontColor
        scanLabel.textColor = ThemeManager.current().lightGrayFontColor
        timeLabel.textColor = ThemeManager.current().lightGrayFontColor
        // Initialization code
    }
    
    static func cellHeight()->CGFloat
    {
        return 100
    }
    
    func update(info:LeaderActivity)
    {
        titleLabel.text = info.title
        timeLabel.text = info.publish_date
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
