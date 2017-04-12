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
        nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        
        contentLabel.textColor = UIColor.black
        timeLabel.textColor = ThemeManager.current().grayFontColor
        
        self.selectionStyle = .none
        
        headerBtn.layer.cornerRadius = 15
        headerBtn.layer.masksToBounds = true
        // Initialization code
    }
    
    func update(_ c:BBSComment)
    {
        let name = c.publish_user_name == nil ? "" : c.publish_user_name!
        let attributeText = NSMutableAttributedString(string: name)
        if !Helper.isStringEmpty(c.receiver_user_name) {
            attributeText.appendAttributeString("回复", color: ThemeManager.current().mainColor, font: UIFont.systemFont(ofSize: 15))
            attributeText.appendAttributeString(c.receiver_user_name!, color: UIColor.black, font: UIFont.systemFont(ofSize: 15))
        }
        nameLabel.attributedText = attributeText
        
        contentLabel.text = c.content
        timeLabel.text = c.publish_date
        
        if !Helper.isStringEmpty(c.publish_user_logo_path)
        {
            headerBtn.sd_setBackgroundImage(with: URL(string: c.publish_user_logo_path!), for: UIControlState(), placeholderImage: UIImage(named: "user_header_default"))
        }
    }
    
    func updateApprove(_ c:Approve)
    {
        let name = c.publish_user_name == nil ? "" : c.publish_user_name!
        let attributeText = NSMutableAttributedString(string: name)
        nameLabel.attributedText = attributeText
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.text = c.advice_content
        contentLabel.textColor = ThemeManager.current().darkGrayFontColor
        timeLabel.text = c.publish_date
        
        if !Helper.isStringEmpty(c.publish_user_logo_path)
        {
            headerBtn.sd_setBackgroundImage(with: URL(string: c.publish_user_logo_path!), for: UIControlState(), placeholderImage: UIImage(named: "user_header_default"))
        }
        replyBtn.isHidden = true
    }
    
    func updateApproveComment(_ c:ApproveComment)
    {
        let name = c.comment_user_name == nil ? "" : c.comment_user_name!
        let attributeText = NSMutableAttributedString(string: name)
        nameLabel.attributedText = attributeText
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.text = c.comment_content
        contentLabel.textColor = ThemeManager.current().darkGrayFontColor
        timeLabel.text = c.comment_date
        
        if !Helper.isStringEmpty(c.comment_user_logo_path)
        {
            headerBtn.sd_setBackgroundImage(with: URL(string: c.comment_user_logo_path!), for: UIControlState(), placeholderImage: UIImage(named: "user_header_default"))
        }
        replyBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
