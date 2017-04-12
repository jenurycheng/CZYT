//
//  TaskModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishTask : NSObject
{
    var taskId:String?
    var task_title:String?
    var task_content:String?
    var task_end_date:String?//yyyy-MM-dd
//    var director:String?//主办人 id
//    var supporter:String? = ""//协办人 id
    var task_projectwork_id:String?
    var assigns:String?
}

class Task: EVObject {
    var task_id:String?
    var task_title:String?
    var task_content:String?
    var task_end_date:String?
    var task_status:String?
    var task_status_name:String?
    var task_accept_user_id:String?
    var task_accept_user_name:String?
    var task_accept_date:String?
    var task_finish_user_id:String?
    var task_finish_user_name:String?
    var task_finish_date:String?
    
    var task_publish_user_id:String?
    var task_publish_user_name:String?
    var task_publish_date:String?
    
    var task_assigner_user_id:String?
    var task_assigner_user_name:String?
    var task_assigner_user_mobile:String?
    var task_assign_date:String?
    
    var task_projectwork_id:String?
    var task_projectwork_title:String?
    
    var assignees:[TaskAssign]?
}

class TaskAssign : EVObject
{
    var assigner_user_id:String?
    var assigner_user_name:String?
    var assigner_user_mobile:String?
    
    var assignee_user_id:String?
    var assignee_user_name:String?
    var assignee_user_mobile:String?
    
    var assignee_user_type:String?
    var assign_date:String?
    
}

class TaskDetail : EVObject
{
    var task_id:String?
    var task_title:String?
    var task_content:String?
    var task_end_date:String?
    var task_status:String?
    var task_status_name:String?
    var task_accept_user_id:String?
    var task_accept_user_name:String?
    var task_accept_date:String?
    var task_finish_user_id:String?
    var task_finish_user_name:String?
    var task_finish_date:String?
    
    var task_publish_user_id:String?
    var task_publish_user_name:String?
    var task_publish_date:String?
    var task_projectwork_id:String?
    var task_projectwork_title:String?
    
    var assign:[TaskAssign]?
    
    var task_comment:TaskResult?
}

class TaskResult : EVObject
{
    var taskcomment_content:String?
    var taskcomment_user_id:String?
    var taskcomment_user_name:String?
    var taskcomment_date:String?
    var photos:[TaskPhoto]?
    var files:[TaskFile]?
}

class TaskPhoto : EVObject
{
    var photo_path:String?
    var photo_thumbnail_path:String?
}

class TaskFile : EVObject
{
    var file_path:String?
    var file_name:String?
    var file_type:String?
}

class Approve : EVObject
{
    var advice_id:String?
    var advice_content:String?
    var advice_type:String?
    var advice_ref_name:String?
    var advice_ref_id:String?
    var advice_type_name:String?
    var publish_user_id:String?
    var publish_user_name:String?
    var publish_user_logo_path:String?
    var publish_date:String?
    var assignees:[ApproveAssigns]?
    
    func getAssignees()->String
    {
        if assignees == nil || assignees!.count == 0 {
            return ""
        }
        var str = ""
        for i in 0 ..< assignees!.count
        {
            if i < assignees!.count - 1
            {
                str = str + assignees![i].assignee_user_name! + ","
            }else{
                str = str + assignees![i].assignee_user_name!
            }
        }
        return str
    }
}

class ApproveAssigns : EVObject
{
    var assignee_user_id:String?
    var assignee_user_name:String?
    var assignee_user_logo_path:String?
    
    var assigner_user_id:String?
    var assigner_user_name:String?
    var assigner_user_logo_path:String?
    var assign_date:String?
}

class ApproveComment : EVObject
{
    var comment_content:String?
    var comment_date:String?
    var comment_user_id:String?
    var comment_user_name:String?
    var comment_user_logo_path:String?
}

class ApproveDetail : EVObject
{
    var advice_id:String?
    var advice_content:String?
    var advice_type:String?
    var advice_ref_name:String?
    var advice_ref_id:String?
    var advice_type_name:String?
    var publish_user_id:String?
    var publish_user_name:String?
    var publish_user_logo_path:String?
    var publish_date:String?
    
    var assign:[ApproveAssigns]?
    var comments:[ApproveComment]?
    
    func getAssignees()->String
    {
        if assign == nil || assign!.count == 0 {
            return ""
        }
        var str = ""
        for i in 0 ..< assign!.count
        {
            if i < assign!.count - 1
            {
                str = str + assign![i].assignee_user_name! + ","
            }else{
                str = str + assign![i].assignee_user_name!
            }
        }
        return str
    }
}
