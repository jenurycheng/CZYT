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
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var detailLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var scanBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!
    
    class func cellHeight()->CGFloat
    {
        return 170
    }
    
    func update(bbs:BBS)
    {
        titleLabel.text = bbs.title
        sourceLabel.text = bbs.original
        detailLabel.text = bbs.summary
        timeLabel.text = bbs.publish_date
        typeLabel.text = bbs.classify
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
