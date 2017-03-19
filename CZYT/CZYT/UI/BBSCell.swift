//
//  BBSCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var scanBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!
    
    @IBOutlet weak var imageViewLeadingConstraint:NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint:NSLayoutConstraint!
    
    class func cellHeight(bbs:BBS)->CGFloat
    {
        if Helper.isStringEmpty(bbs.logo_path)
        {
            let height = Helper.getTextSize(bbs.summary!, font: UIFont.systemFontOfSize(12), size: CGSize(width: GetSWidth()-16, height: CGFloat.max)).height+10
            return 70 + height
        }
        return 150
    }
    
    func update(bbs:BBS)
    {
        let title = bbs.title ?? ""
        let attribute = NSMutableAttributedString(string: "")
        if bbs.isTop() {
            attribute.appendAttributeString("【置顶】", color: UIColor.redColor(), font: titleLabel.font)
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
        
        posterImageView.gm_setImageWithUrlString(bbs.logo_path, title: bbs.title, completedBlock: nil)
        
        if Helper.isStringEmpty(bbs.logo_path)
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
