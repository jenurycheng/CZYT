//
//  ChatGroupTopCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatGroupTopCell: UITableViewCell {

    @IBAction func addGroupBtnClicked()
    {
        
    }
    
    @IBAction func bbsBtnClicked()
    {
        let bbs = BBSViewController()
        let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
        nav?.pushViewController(bbs, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
