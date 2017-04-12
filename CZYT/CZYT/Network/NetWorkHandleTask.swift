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
        
        static var Address_TaskNotify = "TaskNotificationList"
        static var Address_TaskNotifySearch = "TaskNotificationSearch"
        static var Address_TaskNotifyDetail = "TaskNotificationItem"
        
        static var Address_PublishApprove = "PublishAdvice"
        static var Address_GetApproveList = "ShowAdviceList"
        
        static var Address_GetMyApproveList = "ShowMyAdviceList"
        static var Address_GetMyPublishApproveList = "ShowMyPublishedAdviceList"
        static var Address_GetApproveDetail = "ShowAdviceDetail"
        static var Address_ReplyApprove = "ReplayAdvice"
        
        class RequestPublishTask : EVObject
        {
            var task_title:String?
            var task_content:String?
            var task_end_date:String?
//            var director:String?
//            var supporter:String?
            var assigns:String?
            var task_projectwork_id:String?
        }
        
        class func publishTask(_ request:RequestPublishTask?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_PublishTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestMyTask : EVObject
        {
            var offset:String?
            var row_count:String?
        }
        
        class func getMyTask(_ request:RequestMyTask?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_MyTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestMyPublishTask : EVObject
        {
            var offset:String?
            var row_count:String?
        }
        
        class func getMyPublishTask(_ request:RequestMyPublishTask?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_MyPublishTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestTaskDetail : EVObject
        {
            var task_id:String?
        }
        class func getTaskDetail(_ request:RequestTaskDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_TaskDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestAcceptTask : EVObject
        {
            var task_id:String?
        }
        
        class func acceptTask(_ request:RequestAcceptTask?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_AcceptTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestFinishTaskPhoto : EVObject
        {
            var photo_suffix:String?
            var photo_content:String?
        }
        
        class RequestFinishTaskFile : EVObject
        {
            var file_name:String?
            var file_suffix:String?
            var file_content:String?
        }
        
        class RequestFinishTask : EVObject
        {
            var task_id:String?
            var task_comment:String?
            var photos = [RequestFinishTaskPhoto]()
            var files = [RequestFinishTaskFile]()
        }
        
        class func finishTask(_ request:RequestFinishTask?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_FinishTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestAssignTask : EVObject
        {
            var task_id:String?
//            var director:String?
//            var supporter:String?
            var assigns:String?
        }
        class func assignTask(_ request: RequestAssignTask?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_AssignTask, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestTaskNotify : EVObject
        {
            var classify:String?
            var offset:String?
            var row_count:String?
            var key:String?
        }
        class func getTaskNotifyList(_ request: RequestTaskNotify?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_TaskNotify, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
            
        }
        
        class RequestTaskNotifyDetail : EVObject
        {
            var id:String?
        }
        class func getTaskNotifyDetail(_ request: RequestTaskNotifyDetail?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_TaskNotifyDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestPublishApprove : EVObject
        {
            var advice_content:String?
            var advice_type:String?//类型，// 1代表重点项目,2代表动态消息
            var advice_ref_id:String?//重点项目或者动态消息id
            var assigns:String?
        }
        class func publishApprove(_ request:RequestPublishApprove?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_PublishApprove, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetApproveList : EVObject
        {
            var advice_type:String?//类型，// 1代表重点项目,2代表动态消息
            var advice_ref_id:String?//重点项目或者动态消息id
            var offset:String?
            var row_count:String?
        }
        class func getApproveList(_ request:RequestGetApproveList?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_GetApproveList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestApproveDetail : EVObject
        {
            var advice_id:String?
        }
        class func getApproveDetail(_ request:RequestApproveDetail?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_GetApproveDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestMyApproveList : EVObject
        {
            var offset:String?
            var row_count:String?
        }
        
        class func getMyApproveList(_ request:RequestMyApproveList?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_GetMyApproveList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestMyPublishApproveList : EVObject
        {
//            var advice_id:String?
            var offset:String?
            var row_count:String?
        }
        
        class func getMyPublishApproveList(_ request:RequestMyPublishApproveList?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_GetMyPublishApproveList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestReplyApprove : EVObject
        {
            var content:String?
            var advice_id:String?
        }
        
        class func replyApprove(_ request:RequestReplyApprove?, finish:@escaping ((HttpResponseData)->Void))
        {
            NetWorkHandle.PublicNetWorkAccess(Address_ReplyApprove, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
    }
    
}
