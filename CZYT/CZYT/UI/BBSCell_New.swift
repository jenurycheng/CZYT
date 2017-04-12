//
//  BBSCell_New.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/26.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class BBSCell_New: UITableViewCell {
    
    @IBOutlet weak var usernameLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var scanBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        posterImageView.backgroundColor = UIColor.orange
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.cornerRadius = 20
        // Initialization code
    }
    
    func update(_ bbs:BBS)
    {
        let title = bbs.title ?? ""
        let attribute = NSMutableAttributedString(string: "")
        if bbs.isTop() {
            attribute.appendAttributeString("[置顶] ", color: UIColor.red, font: titleLabel.font)
        }
        attribute.appendAttributeString(title, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        titleLabel.attributedText = attribute
        detailLabel.text = ""//bbs.summary
        timeLabel.text = bbs.publish_date
        if !Helper.isStringEmpty(bbs.browser_count)
        {
            scanBtn.setTitle(bbs.browser_count, for: UIControlState())
        }else{
            scanBtn.setTitle("0", for: UIControlState())
        }
        
        if !Helper.isStringEmpty(bbs.comment_count)
        {
            commentBtn.setTitle(bbs.comment_count, for: UIControlState())
        }else{
            commentBtn.setTitle("0", for: UIControlState())
        }
        
        usernameLabel.text = bbs.publish_user_name
        posterImageView.gm_setImageWithUrlString(bbs.publish_user_logo_path, title: bbs.title, completedBlock: nil)
        
    }
    
    func updateDetail(_ bbs:BBSDetail)
    {
        let title = bbs.title ?? ""
        let attribute = NSMutableAttributedString(string: "")
        if bbs.isTop() {
            attribute.appendAttributeString("[置顶] ", color: UIColor.red, font: titleLabel.font)
        }
        attribute.appendAttributeString(title, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        titleLabel.attributedText = attribute
        detailLabel.text = bbs.summary
        timeLabel.text = bbs.publish_date
        if !Helper.isStringEmpty(bbs.browser_count)
        {
            scanBtn.setTitle(bbs.browser_count, for: UIControlState())
        }else{
            scanBtn.setTitle("0", for: UIControlState())
        }
        
        if !Helper.isStringEmpty(bbs.comment_count)
        {
            commentBtn.setTitle(bbs.comment_count, for: UIControlState())
        }else{
            commentBtn.setTitle("0", for: UIControlState())
        }
        
        usernameLabel.text = bbs.publish_user_name
        posterImageView.gm_setImageWithUrlString(bbs.publish_user_logo_path, title: bbs.title, completedBlock: nil)
        
    }
    
    func updateApprove(_ bbs:Approve)
    {
        let title = bbs.advice_ref_name ?? ""
        let attribute = NSMutableAttributedString(string: "")
//        if bbs.isTop() {
//            attribute.appendAttributeString("[置顶] ", color: UIColor.red, font: titleLabel.font)
//        }
        attribute.appendAttributeString(title, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        titleLabel.attributedText = attribute
        detailLabel.numberOfLines = 2
        detailLabel.text = bbs.advice_content
        timeLabel.text = bbs.publish_date
        scanBtn.isHidden = true
//        commentBtn.isHidden = true
        commentBtn.setImage(nil, for: .normal)
        commentBtn.setTitle(bbs.advice_type_name, for: .normal)
        
        let userAttribute = NSMutableAttributedString(string: "")
        let user = bbs.publish_user_name ?? ""
        userAttribute.appendAttributeString(user, color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
        if bbs.assignees?.count != nil && bbs.assignees!.count > 0
        {
            userAttribute.appendAttributeString(":", color: ThemeManager.current().darkGrayFontColor, font: titleLabel.font)
            userAttribute.appendAttributeString(bbs.getAssignees(), color: ThemeManager.current().grayFontColor, font: UIFont.systemFont(ofSize: 12))
        }
        
        usernameLabel.attributedText = userAttribute
        posterImageView.gm_setImageWithUrlString(bbs.publish_user_logo_path, title: "", completedBlock: nil)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
