//
//  BBSCommentCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/13.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSCommentCell: UITableViewCell {

    @IBOutlet weak var headerBtn:UIButton!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var replyBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.font = UIFont.systemFontOfSize(15)
        
        contentLabel.textColor = ThemeManager.current().darkGrayFontColor
        timeLabel.textColor = ThemeManager.current().grayFontColor
        
        self.selectionStyle = .None
        
        headerBtn.layer.cornerRadius = 15
        headerBtn.layer.masksToBounds = true
        // Initialization code
    }
    
    func update(c:BBSComment)
    {
        let name = c.publish_user_name == nil ? "" : c.publish_user_name!
        let attributeText = NSMutableAttributedString(string: name)
        if !Helper.isStringEmpty(c.receiver_user_name) {
            attributeText.appendAttributeString("回复", color: ThemeManager.current().mainColor, font: UIFont.systemFontOfSize(15))
            attributeText.appendAttributeString(c.receiver_user_name!, color: UIColor.blackColor(), font: UIFont.systemFontOfSize(15))
        }
        nameLabel.attributedText = attributeText
        
        contentLabel.text = c.content
        timeLabel.text = c.publish_date
        
        if !Helper.isStringEmpty(c.publish_user_logo_path)
        {
            headerBtn.sd_setBackgroundImageWithURL(NSURL(string: c.publish_user_logo_path!), forState: .Normal, placeholderImage: UIImage(named: "user_header_default"))
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
