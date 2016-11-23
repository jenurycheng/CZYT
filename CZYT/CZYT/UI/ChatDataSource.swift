//
//  ChatDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ChatDataSource: NSObject {
    
    static var NOTIFICATION_QUIT_GROUP = "NOTIFICATION_QUIT_GROUP"
    
    class var sharedInstance : ChatDataSource
    {
        struct Instance{
            static let instance:ChatDataSource = ChatDataSource()
        }
        return Instance.instance
    }
    
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
    
    var groupDetail:GroupDetail?
    func queryGroupDetail(groupId:String, success:((result:GroupDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleChat.RequestQueryGroupDetail()
        request.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.queryGroupDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let u = GroupDetail.parse(dict: data.data as! NSDictionary)
                    self.groupDetail = u
                    success(result: u)
                }
                else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
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
    
    func getGroup(id:String)->Group?
    {
        for g in group
        {
            if g.groupId == id
            {
                return g
            }
        }
        return nil
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
}
