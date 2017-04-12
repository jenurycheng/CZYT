//
//  NetworkHandleUser.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle {
    class NetWorkHandleUser: NSObject {
        static var Address_GetValidCode = "UserValidCode?"
        static var Address_Login = "UserLogin?"
        static var Address_GetToken = "UserToken?"
        static var Address_GetDepartmentList = "DeptList?"
        static var Address_GetContactList = "UserList?"
        static var Address_GetUserDetail = "UserItem"
        static var Address_UpdatePushToken = "DeviceToken"
        static var Address_UpdateUserPhoto = "UpdateUserPhoto"
        
        class RequestUserValidCode : EVObject
        {
            var mobile:String?
        }
        class func getValidCode(_ request:RequestUserValidCode?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetValidCode, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestUserLogin : EVObject
        {
            var mobile:String?
            var validcode:String?
        }
        
        class func login(_ request:RequestUserLogin?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_Login, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetToken : EVObject
        {
            
        }
        
        class func getToken(_ request:RequestGetToken?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetToken, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetDepartmentList : EVObject
        {
            
        }
        class func getDepartmentList(_ request:RequestGetDepartmentList?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartmentList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetContactList : EVObject
        {
            var dept_id:String?
        }
        
        class func getContactList(_ request:RequestGetContactList?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetContactList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetUserDetail : EVObject
        {
            var id:String?
        }
        
        class func getUserDetail(_ request:RequestGetUserDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetUserDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestUpdatePushToken : EVObject
        {
            var device_token_type:String = "IOS"
            var device_token:String?
        }
        
        class func updatePushToken(_ request:RequestUpdatePushToken?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_UpdatePushToken, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestUpdateUserPhoto : EVObject
        {
            var photo_suffix:String?
            var photo_content:String?
        }
        class func updateUserPhoto(_ request:RequestUpdateUserPhoto?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_UpdateUserPhoto, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
    }
}
