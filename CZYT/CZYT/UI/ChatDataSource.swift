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
    
    func createGroup(_ userIds:[String], groupName:String, success:@escaping ((_ result:GroupDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substring(to: ids.characters.index(ids.endIndex, offsetBy: -1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestCreateGroup()
        request.userIds = ids
        request.groupName = groupName
        NetWorkHandle.NetWorkHandleChat.createGroup(request) { (data) in
            if data.isSuccess()
            {
                let d = GroupDetail(dictionary: data.data as! NSDictionary)
                success(d)
            }else{
                failure(data)
            }
        }
    }
    
    func destoryGroup(_ userId:String, groupId:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let r = NetWorkHandle.NetWorkHandleChat.RequestDestroyGroup()
        r.groupId = groupId
        r.userId = userId
        NetWorkHandle.NetWorkHandleChat.destoryGroup(r) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func joinGroup(_ userIds:[String], groupId:String, groupName:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substring(to: ids.characters.index(ids.endIndex, offsetBy: -1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestJoinGroup()
        request.userIds = ids
        request.groupId = groupId
        request.groupName = groupName
        NetWorkHandle.NetWorkHandleChat.joinGroup(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    var groupDetail:GroupDetail?
    func queryGroupDetail(_ groupId:String, success:@escaping ((_ result:GroupDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleChat.RequestQueryGroupDetail()
        request.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.queryGroupDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let u = GroupDetail(dictionary: data.data as! NSDictionary)
                    self.groupDetail = u
                    success(u)
                }
                else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var group = [Group]()
    func queryUserGroup(_ userId:String, success:@escaping ((_ result:[Group]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
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
                        let g = Group(dictionary: dic)
                        array.append(g)
                    }
                }
                self.group = array
                success(array)
            }else{
                failure(data)
            }
        }
    }
    
    func getGroup(_ id:String)->Group?
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
    
    func quitGroup(_ userIds:[String], groupId:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        var ids = ""
        for i in userIds
        {
            ids = ids + i + ","
        }
        if ids.characters.count > 0 {
            ids = ids.substring(to: ids.characters.index(ids.endIndex, offsetBy: -1))
        }
        let request = NetWorkHandle.NetWorkHandleChat.RequestQuitGroup()
        request.userIds = ids
        request.groupId = groupId
        NetWorkHandle.NetWorkHandleChat.quitGroup(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func updateGroup(_ groupId:String, groupName:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleChat.RequestUpdateGroup()
        request.groupId = groupId
        request.groupName = groupName
        NetWorkHandle.NetWorkHandleChat.updateGroup(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
}
