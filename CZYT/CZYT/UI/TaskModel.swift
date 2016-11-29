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
    var director:String?//主办人 id
    var supporter:String? = ""//协办人 id
}

class Task: Reflect {
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
    
    var assignees:[TaskAssign]?
}

class TaskAssign : Reflect
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

class TaskDetail : Reflect
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
    
    var assign:[TaskAssign]?
    
    var task_comment:TaskResult?
}

class TaskResult : Reflect
{
    var taskcomment_content:String?
    var taskcomment_user_id:String?
    var taskcomment_user_name:String?
    var taskcomment_date:String?
    var photos:[TaskPhoto]?
}

class TaskPhoto : Reflect
{
    var photo_path:String?
    var photo_thumbnail_path:String?
}