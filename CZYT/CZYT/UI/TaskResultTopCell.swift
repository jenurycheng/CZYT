//
//  TaskResultTopCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/23.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskResultTopCell: UICollectionViewCell {

    @IBOutlet weak var userLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    class func cellSize(content:String?)->CGSize
    {
        if content == nil {
            return CGSize(width: GetSWidth(), height: 60)
        }
        let height = Helper.getTextSize(content!, font: UIFont.systemFontOfSize(14), size: CGSize(width: GetSWidth()-20, height: CGFloat.max)).height
        return CGSize(width: GetSWidth(), height: 60 + height + 20 + 10)
    }
    
    func update(result:TaskDetail)
    {
        let name = result.task_comment?.taskcomment_user_name == nil ? "" : result.task_comment!.taskcomment_user_name!
        userLabel.text = "完成者: " + name
        
        timeLabel.text = result.task_finish_date
        
        contentLabel.text = result.task_comment?.taskcomment_content
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
