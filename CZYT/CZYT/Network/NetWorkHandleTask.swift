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
        static var Address_TaskDetail = "ShowTaskDetail"
        
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
        
        class RequestMyPublishTask : Reflect
        {
            var offset:Int?
            var row_count:Int?
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
    }
    
}
