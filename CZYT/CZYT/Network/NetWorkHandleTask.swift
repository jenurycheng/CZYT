//
//  NetWorkHandleTask.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/14.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle
{
    
    class NetWorkHandleTask: NSObject {
        
        static var Address_PublishTask = "PublishTask?"
        static var Address_MyPublishTask = "ShowMyPublishedTask?"
        static var Address_MyTask = "ShowMyTask"
        static var Address_TaskDetail = "ShowTaskDetail?"
        static var Address_AcceptTask = "AcceptTask?"
        static var Address_FinishTask = "FinishTask?"
        static var Address_AssignTask = "AssignTask"
        
        class RequestPublishTask : Reflect
        {
            var task_title:String?
            var task_content:String?
            var task_end_date:String?
            var director:String?
            var supporter:String?
        }
        
        class func publishTask(request:RequestPublishTask?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_PublishTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestMyTask : Reflect
        {
            var offset:String?
            var row_count:String?
        }
        
        class func getMyTask(request:RequestMyTask?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_MyTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestMyPublishTask : Reflect
        {
            var offset:String?
            var row_count:String?
        }
        
        class func getMyPublishTask(request:RequestMyPublishTask?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_MyPublishTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestTaskDetail : Reflect
        {
            var task_id:String?
        }
        class func getTaskDetail(request:RequestTaskDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_TaskDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestAcceptTask : Reflect
        {
            var task_id:String?
        }
        
        class func acceptTask(request:RequestAcceptTask?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_AcceptTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestFinishTaskPhoto : Reflect
        {
            var photo_suffix:String?
            var photo_content:String?
        }
        
        class RequestFinishTask : Reflect
        {
            var task_id:String?
            var task_comment:String?
            var photos = [RequestFinishTaskPhoto]()
        }
        
        class func finishTask(request:RequestFinishTask?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_FinishTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestAssignTask : Reflect
        {
            var task_id:String?
            var director:String?
            var supporter:String?
        }
        class func assignTask(request: RequestAssignTask?, finish:((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_AssignTask, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }
    
}
