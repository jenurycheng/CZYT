//
//  HomeCell2.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class HomeCell2: UICollectionViewCell {

    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var numLabel:UILabel!
    
    class func cellSize()->CGSize
    {
        return CGSize(width: (GetSWidth()-40)/3, height: (GetSWidth()-40)/3)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.backgroundColor = Helper.parseColor(0x00000022)
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.masksToBounds = true
        
        numLabel.backgroundColor = ThemeManager.current().mainColor
        numLabel.textColor = UIColor.whiteColor()
        numLabel.layer.cornerRadius = 10
        numLabel.layer.masksToBounds = true
        // Initialization code
    }

}
