//
//  ImageCollectionCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import Photos

protocol ImageCollectionCellDelegate : NSObjectProtocol {
    func deleteBtnClicked(_ cell:ImageCollectionCell)
}

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var deleteBtn:UIButton!
    weak var delegate:ImageCollectionCellDelegate?
    
    class func cellSize()->CGSize
    {
        let width = (GetSWidth()-35)/4
        return CGSize(width: width, height: width)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    @IBAction func deleteBtnClicked()
    {
        if delegate != nil
        {
            delegate?.deleteBtnClicked(self)
        }
    }

    func updateView(_ r:UIImage)
    {
        imageView.image = r
    }
    
    func updatePhoto(_ photo:TaskPhoto)
    {
        imageView.gm_setImageWithUrlString(photo.photo_path, title: "", completedBlock: nil)
    }
    
}
