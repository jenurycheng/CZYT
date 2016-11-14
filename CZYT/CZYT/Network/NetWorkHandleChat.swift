//
//  NetWorkHandleChat.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle
{
    class NetWorkHandleChat: NSObject {
        static var Address_CreateGroup = "GroupCreate?"
        static var Address_DestoryGroup = "GroupDismiss?"
        static var Address_JoinGroup = "GroupJoin?"
        static var Address_QueryGroupUser = "GroupQueryUser"
        static var Address_QuitGroup = "GroupQuit"
        static var Address_UpdateGroup = "GroupRefresh"
        
        class RequestCreateGroup : Reflect
        {
            var userIds:String?
            var groupId:String?
            var groupName:String?
        }
        
        class func createGroup(request:RequestCreateGroup?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_CreateGroup, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestDestroyGroup : Reflect
        {
            var userId:String?
            var groupId:String?
        }
        
        class func destoryGroup(request:RequestDestroyGroup?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_DestoryGroup, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestJoinGroup : Reflect
        {
            var userIds:String?
            var groupId:String?
            var groupName:String?
        }
        
        class func joinGroup(request:RequestJoinGroup?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_JoinGroup, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestQueryGroupUser : Reflect
        {
            var groupId:String?
        }
        
        class func queryGroupUser(request:RequestQueryGroupUser?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_QueryGroupUser, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestQuitGroup : Reflect
        {
            var userIds:String?
            var groupId:String?
        }
        class func quitGroup(request:RequestQuitGroup?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_QuitGroup, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestUpdateGroup : Reflect
        {
            var groupId:String?
            var groupName:String?
        }
        
        class func updateGroup(request:RequestUpdateGroup?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_UpdateGroup, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }
}
