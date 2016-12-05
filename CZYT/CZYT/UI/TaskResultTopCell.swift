//
//  TaskResultTopCell.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/23.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskResultTopCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var userLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    class func cellSize(content:String?)->CGSize
    {
        if content == nil {
            return CGSize(width: GetSWidth(), height: 60 + 0 + 20 + 10 + 20)
        }
        let height = Helper.getTextSize(content!, font: UIFont.systemFontOfSize(14), size: CGSize(width: GetSWidth()-20, height: CGFloat.max)).height
        return CGSize(width: GetSWidth(), height: 60 + height + 20 + 10 + 20)
    }
    
    func update(result:TaskDetail)
    {
        if result.task_status! == "accepted"//待接受
        {
            titleLabel.text = "任务已接受"
            
            let name = result.task_accept_user_name == nil ? "" : result.task_accept_user_name!
            userLabel.text = "接受者: " + name
            
            //        timeLabel.text = "完成时间: " + Helper.formatDateString(result.task_finish_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
            timeLabel.text = "接受时间: " + result.task_accept_date!
            contentLabel.text = ""
        }else if result.task_status! == "finished"//已完成
        {
            titleLabel.text = "任务已完成"
            
            let name = result.task_comment?.taskcomment_user_name == nil ? "" : result.task_comment!.taskcomment_user_name!
            userLabel.text = "完成者: " + name
            
            //        timeLabel.text = "完成时间: " + Helper.formatDateString(result.task_finish_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
            timeLabel.text = "完成时间: " + result.task_finish_date!
            contentLabel.text = result.task_comment?.taskcomment_content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
