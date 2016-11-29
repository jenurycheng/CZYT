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
    
    func isMyLevel()->Bool
    {
        var id = self.dept_id
        while id != DepartmentTree.rootDepartmentID{
            if id == UserInfo.sharedInstance.dept_id
            {
                return true
            }
            for d in ContactDataSource.sharedInstance.department
            {
                if d.dept_id == id
                {
                    id = d.dept_parent_id
                    break
                }
            }
        }
        return false
    }
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

class GroupDetail : Reflect
{
    var create_date:String?
    var create_user_logo_path:String?
    var create_user_id:String?
    var create_user_name:String?
    var groupName:String?
    var create_user_mobile:String?
    var groupId:String?
    var users:[GroupUser]?
}

class GroupUser : Reflect
{
    var user_logo_path:String?
    var user_mobile:String?
    var userId:String?
    var user_name:String?
}
