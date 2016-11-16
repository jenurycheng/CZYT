//
//  ChatModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/15.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class Department: Reflect {
    var dept_id:String?
    var dept_parent_id:String?
    var dept_name:String?
}

class Group : Reflect
{
    var groupId:String?
    var groupName:String?
    var create_user_id:String?
    var create_user_name:String?
    var create_user_mobile:String?
    var create_user_logo_path:String?
    var create_date:String?
}
