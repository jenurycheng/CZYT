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
        static var Address_GetLeaderSearch = "LeaderActivitySearch?"
        
        static var Address_GetFileActivity = "PolicyFileList?"
        static var Address_GetFileActivityDetail = "PolicyFileItem?"
        static var Address_GetFileSearch = "PolicyFileSearch"
        
        static var Address_GetWorkStatusActivity = "WorkStatusList?"
        static var Address_GetWorkStatusActivityDetail = "WorkStatusItem?"
        static var Address_GetWorkStatusSearch = "WorkStatusSearch"
        
        static var Address_GetAreaStatusActivity = "XianStatusList"
        static var Address_GetAreaStatusActivityDetail = "XianStatusItem"
        
        static var Address_GetDepartStatusActivity = "BumenStatusList"
        static var Address_GetDepartStatusActivityDetail = "BumenStatusItem"
        
        static var Address_GetProjectWorkActivity = "ProjectWorkList"
        static var Address_GetProjectWorkActivityDetail = "ProjectWorkItem"
        static var Address_GetProjectWorkSearch = "ProjectWorkSearch"
        
        static var Address_GetWebLink = "LinkList"
        static var Address_GetModuleType = "ModuleClassifyList"
        
        static var Address_CheckAppUpdate = "CheckLatestVersion"

        class RequestHomeActivity : EVObject
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getHomeActivity(_ request:RequestHomeActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetHomeActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestLeaderActivity : EVObject
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
            var key:String?
        }
        class func getLeaderActivity(_ request:RequestLeaderActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetLeaderActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
            
        }
        
        class RequestLeaderActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getLeaderActivityDetail(_ request:RequestLeaderActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetLeaderActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestFileActivity : EVObject
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
            var key:String?
        }
        class func getFileActivity(_ request:RequestFileActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetFileActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestFileActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getFileActivityDetail(_ request:RequestFileActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetFileActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestWorkStatusActivity : EVObject
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
            var key:String?
        }
        class func getWorkStatusActivity(_ request:RequestWorkStatusActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWorkStatusActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestWorkStatusActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getWorkStatusActivityDetail(_ request:RequestWorkStatusActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWorkStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestAreaStatusActivity : EVObject
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        
        class func getAreaStatusActivity(_ request:RequestAreaStatusActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetAreaStatusActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestAreaStatusActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getAreaStatusActivityDetail(_ request:RequestAreaStatusActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetAreaStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestDepartStatusActivity : EVObject
        {
            var offset:String?  //0开始
            var row_count:String?
        }
        
        class func getDepartStatusActivity(_ request:RequestDepartStatusActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartStatusActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestDepartStatusActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getDepartStatusActivityDetail(_ request:RequestDepartStatusActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetDepartStatusActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestProjectWorkActivity : EVObject
        {
            var classify:String?//省级，资阳，成都, 县区，中央
            var offset:String?  //0开始
            var row_count:String?
            var key:String?
        }
        class func getProjectWorkActivity(_ request:RequestProjectWorkActivity?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetProjectWorkActivity, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestProjectWorkActivityDetail : EVObject
        {
            var id:String?
        }
        
        class func getProjectWorkActivityDetail(_ request:RequestProjectWorkActivityDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetProjectWorkActivityDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestWebLink : EVObject
        {
            
        }
        
        class func getWebLink(_ request:RequestWebLink?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetWebLink, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestModuleType : EVObject
        {
            var classify:String?//LeaderActivity,PolicyFile,WorkStatus,ProjectWork,Exchange,TaskNotification
        }
        
        class func getModuleType(_ request:RequestModuleType?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetModuleType, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestCheckAppUpdate : EVObject
        {
            var os:String = "IOS"
        }
        
        class func checkAppUpdate(_ request:RequestCheckAppUpdate?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_CheckAppUpdate, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: true)
        }
    }
}
