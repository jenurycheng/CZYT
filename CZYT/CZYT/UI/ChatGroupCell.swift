//
//  ChatGroupCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatGroupCell: UITableViewCell {

    @IBOutlet weak var headerImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(g:Group)
    {
        titleLabel.text = g.groupName
    }
    
    func updateUserInfo(u:UserInfo)
    {
        let name = u.nickname == nil ? "" : u.nickname!
        titleLabel.text = name
        
        if u.id == UserInfo.sharedInstance.id
        {
            titleLabel.text = name + "(我自己)"
            self.accessoryType = .None
        }else{
            self.accessoryType = .DisclosureIndicator
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
