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
    @IBOutlet weak var checkedImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkedImageView.isHidden = true
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerImageView.layer.cornerRadius = 5
        headerImageView.layer.masksToBounds = true
    }
    
    class func cellHeight()->CGFloat
    {
        return  50
    }
    
    func update(_ g:Group)
    {
        titleLabel.text = g.groupName
    }
    
    func setChecked(_ b:Bool)
    {
        checkedImageView.isHidden = false
        if b
        {
            checkedImageView.image = UIImage(named: "user_selected")
        }else{
            checkedImageView.image = UIImage(named: "user_not_selected")
        }
    }

    func updateUserInfo(_ u:UserInfo)
    {
        let name = u.nickname == nil ? "" : u.nickname!
        titleLabel.text = name
        
        if u.id == UserInfo.sharedInstance.id
        {
            titleLabel.text = name + "(我自己)"
        }
        
        headerImageView.gm_setImageWithUrlString(u.logo_path, title: u.nickname, completedBlock: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
