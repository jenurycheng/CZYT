//
//  BBSTopDetailCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/26.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class BBSTopDetailCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var topLabel:UILabel!
    @IBOutlet weak var scanBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        posterImageView.backgroundColor = UIColor.orangeColor()
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 20
        // Initialization code
    }
    
    func update(bbs:BBS)
    {
        topLabel.hidden = true
        let title = bbs.title ?? ""
        let attribute = NSMutableAttributedString(string: "")
        if bbs.isTop() {
            attribute.appendAttributeString("[置顶] ", color: UIColor.redColor(), font: titleLabel.font)
        }
        attribute.appendAttributeString(title, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        titleLabel.attributedText = attribute
        detailLabel.text = bbs.summary
        timeLabel.text = bbs.publish_date
        if !Helper.isStringEmpty(bbs.browser_count)
        {
            scanBtn.setTitle(bbs.browser_count, forState: .Normal)
        }else{
            scanBtn.setTitle("0", forState: .Normal)
        }
        
        if !Helper.isStringEmpty(bbs.comment_count)
        {
            commentBtn.setTitle(bbs.comment_count, forState: .Normal)
        }else{
            commentBtn.setTitle("0", forState: .Normal)
        }
        
        usernameLabel.text = bbs.publish_user_name
        posterImageView.gm_setImageWithUrlString(bbs.publish_user_logo_path, title: bbs.title, completedBlock: nil)
        
    }
    
    func updateDetail(bbs:BBSDetail)
    {
        let title = bbs.title ?? ""
        let attribute = NSMutableAttributedString(string: "")
        if bbs.isTop() {
            topLabel.text = "[置顶]"
            topLabel.textColor = UIColor.redColor()
        }else{
            topLabel.text = ""
            topLabel.textColor = ThemeManager.current().grayFontColor
        }
        attribute.appendAttributeString(title, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        titleLabel.attributedText = attribute
        detailLabel.text = bbs.content
        timeLabel.text = bbs.publish_date
        if !Helper.isStringEmpty(bbs.browser_count)
        {
            scanBtn.setTitle(bbs.browser_count, forState: .Normal)
        }else{
            scanBtn.setTitle("0", forState: .Normal)
        }
        
        if !Helper.isStringEmpty(bbs.comment_count)
        {
            commentBtn.setTitle(bbs.comment_count, forState: .Normal)
        }else{
            commentBtn.setTitle("0", forState: .Normal)
        }
        
        usernameLabel.text = bbs.publish_user_name
        posterImageView.gm_setImageWithUrlString(bbs.publish_user_logo_path, title: bbs.title, completedBlock: nil)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
