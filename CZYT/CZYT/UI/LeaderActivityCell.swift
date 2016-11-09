//
//  LeaderActivityCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivityCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    class func cellHeight()->CGFloat
    {
        return 150
    }
    
    func update(leader:LeaderActivity)
    {
        titleLabel.text = leader.title
        posterImageView.gm_setImageWithUrlString(leader.logo_path, title: leader.title, completedBlock: nil)
        sourceLabel.text = leader.original
        detailLabel.text = leader.summary
        timeLabel.text = leader.publish_date
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
