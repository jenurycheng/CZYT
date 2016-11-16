//
//  ChatDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatDataSource: NSObject {
    
    func createGroup(userIds:[String], groupName:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substringToIndex(ids.endIndex.advancedBy(-1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestCreateGroup()
        request.userIds = ids
        request.groupName = groupName
        NetWorkHandle.NetWorkHandleChat.createGroup(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func destoryGroup(userId:String, groupId:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let r = NetWorkHandle.NetWorkHandleChat.RequestDestroyGroup()
        r.groupId = groupId
        r.userId = userId
        NetWorkHandle.NetWorkHandleChat.destoryGroup(r) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func joinGroup(userIds:[String], groupId:String, groupName:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substringToIndex(ids.endIndex.advancedBy(-1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestJoinGroup()
        request.userIds = ids
        request.groupId = groupId
        request.groupName = groupName
        NetWorkHandle.NetWorkHandleChat.joinGroup(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func queryGroupUser(groupId:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let r = NetWorkHandle.NetWorkHandleChat.RequestQueryGroupUser()
        r.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.queryGroupUser(r) { (data) in
            if data.isSuccess()
            {
                
            }else{
                
            }
        }
    }
    
    var group = [Group]()
    func queryUserGroup(userId:String, success:((result:[Group]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleChat.RequestQueryUserGroup()
        request.userId = userId
        NetWorkHandle.NetWorkHandleChat.queryUserGroup(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? Array<NSDictionary>
                var array = [Group]()
                if r != nil
                {
                    for dic in r!
                    {
                        let g = Group.parse(dict: dic)
                        array.append(g)
                    }
                }
                self.group = array
                success(result: array)
            }else{
                failure(error: data)
            }
        }
    }
    
    func quitGroup(userIds:[String], groupId:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substringToIndex(ids.endIndex.advancedBy(-1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestQuitGroup()
        request.userIds = ids
        request.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.quitGroup(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func updateGroup(groupId:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleChat.RequestUpdateGroup()
        request.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.updateGroup(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    var department = [Department]()
    func getDepartmentList(success:((result:[Department]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestGetDepartmentList()
        NetWorkHandle.NetWorkHandleUser.getDepartmentList(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? Array<NSDictionary>
                var array = [Department]()
                if r != nil
                {
                    for dic in r!
                    {
                        let d = Department.parse(dict: dic)
                        array.append(d)
                    }
                }
                self.department = array
                success(result: array)
            }else{
                failure(error: data)
            }
        }
    }
    
    var contact = [UserInfo]()
    func getContactList(groupId:String, success:((result:[UserInfo]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestGetContactList()
        request.dept_id = groupId
        NetWorkHandle.NetWorkHandleUser.getContactList(request) { (data) in
            if data.isSuccess()
            {
                var array = [UserInfo]()
                let r = data.data as? Array<NSDictionary>
                if r != nil
                {
                    for dic in r!
                    {
                        let u = UserInfo.parse(dict: dic)
                        array.append(u)
                    }
                }
                self.contact = array
                success(result: array)
            }else{
                failure(error: data)
            }
        }
    }
}
