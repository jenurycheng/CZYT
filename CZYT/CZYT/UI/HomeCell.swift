//
//  HomeCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView:UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
    
    class func cellSize()->CGSize
    {
        return CGSize(width: (GetSWidth()-40)/3, height: (GetSWidth()-40)/3)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
