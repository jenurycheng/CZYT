//
//  FileCollectionCell.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/18.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

protocol FileCollectionCellDelegate : NSObjectProtocol {
    func fileDeleteBtnClicked(cell:FileCollectionCell)
}

class FileCollectionCell: UICollectionViewCell {

    @IBOutlet weak var addBtn:UIButton!
    @IBOutlet weak var deleteBtn:UIButton!
    weak var delegate:FileCollectionCellDelegate?
    
    class func cellSize()->CGSize
    {
        let width = GetSWidth()
        return CGSize(width: width, height: 40)
    }
    
    func update(path:String)
    {
        let s:NSString = path;
        
        addBtn.setTitle(s.lastPathComponent, forState: .Normal)
    }
    
    func updateFile(f:TaskFile)
    {
        addBtn.setTitle(f.file_name, forState: .Normal)
    }
    
    @IBAction func deleteBtnClicked()
    {
        if delegate != nil
        {
            delegate?.fileDeleteBtnClicked(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = ThemeManager.current().foregroundColor
        // Initialization code
    }

}
