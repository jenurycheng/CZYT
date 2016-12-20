//
//  NetWorkHandleApp.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle
{
    class NetWorkHandleApp: NSObject {
        static var Address_GetHomeActivity = "HomeSliderList"
        
        static var Address_GetLeaderActivity = "LeaderActivityList?"
        static var Address_GetLeaderActivityDetail = "LeaderActivityItem?"
        
        static var Address_GetFileActivity = "PolicyFileList?"
        static var Address_GetFileActivityDetail = "PolicyFileItem?"
        
        static var Address_GetWorkStatusActivity = "WorkStatusList?"
        static var Address_GetWorkStatusActivityDetail = "WorkStatusItem?"
        
        static var Address_GetAreaStatusActivity = "XianStatusList"
        static var Address_GetAreaStatusActivityDetail = "XianStatusItem"
        
        static var Address_GetDepartStatusActivity = "BumenStatusList"
        static var Address_GetDepartStatusActivityDetail = "BumenStatusItem"
        
        static var Address_GetProjectWorkActivity = "ProjectWorkList"
        static var Address_GetProjectWorkActivityDetail = "ProjectWorkItem"
        
        static var Address_GetWebLink = "LinkList"
        static var Address_GetModuleType = "ModuleClassifyList"
        
        static var Address_CheckAppUpdate = "CheckLatestVersion"

        class RequestHomeActivity : Reflect
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getHomeActivity(request:RequestHomeActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetHomeActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestLeaderActivity : Reflect
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getLeaderActivity(request:RequestLeaderActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetLeaderActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestLeaderActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getLeaderActivityDetail(request:RequestLeaderActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetLeaderActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestFileActivity : Reflect
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getFileActivity(request:RequestFileActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetFileActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestFileActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getFileActivityDetail(request:RequestFileActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetFileActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestWorkStatusActivity : Reflect
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getWorkStatusActivity(request:RequestWorkStatusActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWorkStatusActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestWorkStatusActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getWorkStatusActivityDetail(request:RequestWorkStatusActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWorkStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestAreaStatusActivity : Reflect
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        
        class func getAreaStatusActivity(request:RequestAreaStatusActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetAreaStatusActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestAreaStatusActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getAreaStatusActivityDetail(request:RequestAreaStatusActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetAreaStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestDepartStatusActivity : Reflect
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        
        class func getDepartStatusActivity(request:RequestDepartStatusActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartStatusActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestDepartStatusActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getDepartStatusActivityDetail(request:RequestDepartStatusActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        
        
        class RequestProjectWorkActivity : Reflect
        {
            var classify:String?//省级，资阳，成都, 县区，中央
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getProjectWorkActivity(request:RequestProjectWorkActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetProjectWorkActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestProjectWorkActivityDetail : Reflect
        {
            var id:String?
        }
        
        class func getProjectWorkActivityDetail(request:RequestProjectWorkActivityDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetProjectWorkActivityDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestWebLink : Reflect
        {
            
        }
        
        class func getWebLink(request:RequestWebLink?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWebLink, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestModuleType : Reflect
        {
            var classify:String?//LeaderActivity,PolicyFile,WorkStatus,ProjectWork,Exchange
        }
        
        class func getModuleType(request:RequestModuleType?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetModuleType, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: true)
        }
        
        class RequestCheckAppUpdate : Reflect
        {
            var os:String = "IOS"
        }
        
        class func checkAppUpdate(request:RequestCheckAppUpdate?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_CheckAppUpdate, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: true)
        }
    }
}
