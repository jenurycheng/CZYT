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
            ids = i + ","
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
            ids = i + ","
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
    
    func quitGroup(userIds:[String], groupId:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = i + ","
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
}
