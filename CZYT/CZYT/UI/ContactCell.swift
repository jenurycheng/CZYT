//
//  ContactCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var headerImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    @IBOutlet weak var checkedImageView:UIImageView!
    
    @IBOutlet weak var nameHeight:NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkedImageView.hidden = true
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
    
    func setChecked(b:Bool)
    {
        checkedImageView.hidden = false
        if b
        {
            checkedImageView.image = UIImage(named: "user_selected")
        }else{
            checkedImageView.image = UIImage(named: "user_not_selected")
        }
    }

    func updateUserInfo(u:UserInfo, showMobile:Bool = true)
    {
        let name = u.nickname == nil ? "" : u.nickname!
        titleLabel.text = name
        phoneLabel.text = showMobile ? u.mobile : ""
        nameHeight.constant = showMobile ? 30 : 40
        
        if u.id == UserInfo.sharedInstance.id
        {
            titleLabel.text = name + "(我自己)"
        }
        
        headerImageView.gm_setImageWithUrlString(u.logo_path, title: u.nickname, completedBlock: nil)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
