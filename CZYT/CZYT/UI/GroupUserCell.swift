//
//  GroupUserCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class GroupUserCell: UICollectionViewCell {

    @IBOutlet weak var headerImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    
    class func cellSize()->CGSize
    {
        let width = (GetSWidth() - 50)/4
        return CGSize(width: width, height: width+30)
    }
    
    func update(user:GroupUser)
    {
        headerImageView.gm_setImageWithUrlString(user.user_logo_path, title: user.user_name, completedBlock: nil)
        nameLabel.text = user.user_name
    }
    
    func updateToAddBtn()
    {
        headerImageView.image = UIImage(named: "user_header_default")
        nameLabel.text = "添加成员"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
