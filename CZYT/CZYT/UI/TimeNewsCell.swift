//
//  TimeNewsCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/2/19.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TimeNewsCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var posterImageViewHeight:NSLayoutConstraint!
    @IBOutlet weak var contentTextHeight:NSLayoutConstraint!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentBgView:UIView!
    
    
    static func cellHeight(info:LeaderActivity)->CGFloat
    {
        let baseHeight:CGFloat = 90
        var imageHeight:CGFloat = 0
        if Helper.isStringEmpty(info.logo_path)
        {
            imageHeight = 0
        }else{
            imageHeight = (GetSWidth()-40) * 3 / 5
        }
        var textHeight:CGFloat = 0
        if !Helper.isStringEmpty(info.summary) {
            textHeight = Helper.getTextSize(info.summary!, font: UIFont.systemFontOfSize(13), size: CGSizeMake(GetSWidth() - 40, CGFloat.max)).height + 20
        }
        return baseHeight + imageHeight + textHeight
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        self.clipsToBounds = true
        contentLabel.textColor = ThemeManager.current().grayFontColor
        sourceLabel.textColor = ThemeManager.current().lightGrayFontColor
        timeLabel.textColor = ThemeManager.current().lightGrayFontColor
        contentBgView.layer.cornerRadius = 5
        contentBgView.layer.masksToBounds = true
        // Initialization code
    }
    
    func update(info:LeaderActivity)
    {
        titleLabel.text = info.title
        if Helper.isStringEmpty(info.logo_path) {
            posterImageViewHeight.constant = 0
        }else{
            posterImageViewHeight.constant = (GetSWidth()-40) * 3 / 5
            posterImageView.gm_setImageWithUrlString(info.logo_path, title: info.title, completedBlock: nil)
        }
        
        var textHeight:CGFloat = 0
        if !Helper.isStringEmpty(info.summary) {
            textHeight = Helper.getTextSize(info.summary!, font: UIFont.systemFontOfSize(13), size: CGSizeMake(GetSWidth() - 40, CGFloat.max)).height + 20
        }
        contentTextHeight.constant = textHeight
        contentLabel.text = info.summary
        sourceLabel.text = "来源: " + (info.original ?? "")
        timeLabel.text = info.publish_date
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
