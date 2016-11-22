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
        
        class RequestUserValidCode : Reflect
        {
            var mobile:String?
        }
        class func getValidCode(request:RequestUserValidCode?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetValidCode, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestUserLogin : Reflect
        {
            var mobile:String?
            var validcode:String?
        }
        
        class func login(request:RequestUserLogin?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_Login, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestGetToken : Reflect
        {
            
        }
        
        class func getToken(request:RequestGetToken?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetToken, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestGetDepartmentList : Reflect
        {
            
        }
        class func getDepartmentList(request:RequestGetDepartmentList?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartmentList, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestGetContactList : Reflect
        {
            var dept_id:String?
        }
        
        class func getContactList(request:RequestGetContactList?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetContactList, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestGetUserDetail : Reflect
        {
            var id:String?
        }
        
        class func getUserDetail(request:RequestGetUserDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetUserDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }
}
