//
//  ProjectWorkCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ProjectWorkCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var accountLabel:UILabel!
 
    @IBOutlet weak var imageViewLeadingConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint:NSLayoutConstraint!
    
    class func cellHeight(leader:LeaderActivity)->CGFloat
    {
        if Helper.isStringEmpty(leader.logo_path)
        {
            let height = Helper.getTextSize(leader.summary!, font: UIFont.systemFontOfSize(12), size: CGSize(width: GetSWidth()-16, height: CGFloat.max)).height+10
            return 90 + height
        }
        return 170
    }
    
    func update(leader:LeaderActivity)
    {
        titleLabel.text = leader.title
        posterImageView.gm_setImageWithUrlString(leader.logo_path, title: leader.title, completedBlock: nil)
        sourceLabel.text = leader.original
        detailLabel.text = leader.summary
        timeLabel.text = leader.publish_date
        typeLabel.text = leader.type
        var account = "0"
        if !Helper.isStringEmpty(leader.amount) {
            account = leader.amount!
        }
        let attribute = NSMutableAttributedString()
        attribute.appendAttributeString("项目金额：", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
        attribute.appendAttributeString("\(account)元", color: UIColor.redColor(), font: UIFont.systemFontOfSize(15))
        
        accountLabel.attributedText = attribute
        
        if Helper.isStringEmpty(leader.logo_path)
        {
            imageViewLeadingConstraint.constant = 0
            imageViewWidthConstraint.constant = 0
        }else{
            imageViewLeadingConstraint.constant = 8
            imageViewWidthConstraint.constant = 125
        }
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
