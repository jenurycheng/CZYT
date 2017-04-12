//
//  BBSCommentChildCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/30.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class BBSCommentChildCell: UITableViewCell {

    @IBOutlet weak var contentLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.textColor = ThemeManager.current().grayFontColor
        self.selectionStyle = .none
        // Initialization code
    }
    
    func update(_ c:BBSComment)
    {
        let name = c.publish_user_name == nil ? "" : c.publish_user_name!
        let attributeText = NSMutableAttributedString(string: "")
        attributeText.appendAttributeString(name, color: ThemeManager.current().blueColor, font: UIFont.systemFont(ofSize: 13))
        if !Helper.isStringEmpty(c.receiver_user_name) {
            attributeText.appendAttributeString(": ", color: ThemeManager.current().blueColor, font: UIFont.systemFont(ofSize: 13))
            attributeText.appendAttributeString(c.content!, color: UIColor.black, font: UIFont.systemFont(ofSize: 13))
        }
        contentLabel.attributedText = attributeText
        
//        contentLabel.text = c.content
//        timeLabel.text = c.publish_date
//        
//        if !Helper.isStringEmpty(c.publish_user_logo_path)
//        {
//            headerBtn.sd_setBackgroundImageWithURL(NSURL(string: c.publish_user_logo_path!), forState: .Normal, placeholderImage: UIImage(named: "user_header_default"))
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
