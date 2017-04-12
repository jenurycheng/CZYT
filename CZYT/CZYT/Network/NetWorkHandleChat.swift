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
        static var Address_QueryGroupDetail = "QueryUserList?"
        static var Address_QuitGroup = "GroupQuit?"
        static var Address_UpdateGroup = "GroupRefresh?"
        static var Address_QueryUserGroup = "QueryGroupList?"
        
        class RequestCreateGroup : EVObject
        {
            var userIds:String?
            var groupName:String?
        }
        
        class func createGroup(_ request:RequestCreateGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_CreateGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestDestroyGroup : EVObject
        {
            var userId:String?
            var groupId:String?
        }
        
        class func destoryGroup(_ request:RequestDestroyGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_DestoryGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestJoinGroup : EVObject
        {
            var userIds:String?
            var groupId:String?
            var groupName:String?
        }
        
        class func joinGroup(_ request:RequestJoinGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_JoinGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestQueryGroupDetail : EVObject
        {
            var groupId:String?
        }
        
        class func queryGroupDetail(_ request:RequestQueryGroupDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_QueryGroupDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestQueryUserGroup : EVObject
        {
            var userId:String?
        }
        
        class func queryUserGroup(_ request:RequestQueryUserGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_QueryUserGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestQuitGroup : EVObject
        {
            var userIds:String?
            var groupId:String?
        }
        class func quitGroup(_ request:RequestQuitGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_QuitGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestUpdateGroup : EVObject
        {
            var groupId:String?
            var groupName:String?
        }
        
        class func updateGroup(_ request:RequestUpdateGroup?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_UpdateGroup, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
    }
}
