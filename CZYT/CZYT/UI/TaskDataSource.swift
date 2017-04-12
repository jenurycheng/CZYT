//
//  TaskDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskDataSource: NSObject {
    
    var pageSize = 10
    
    var myTask = [Task]()
    func getMyTask(_ isFirst:Bool, success:@escaping ((_ result:[Task]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestMyTask()
        request.offset = "\(self.myTask.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getMyTask(request) { (data) in
            if data.isSuccess()
            {
                var rs = [Task]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = Task(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.myTask.append(contentsOf: rs)
                if isFirst
                {
                    self.myTask = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var publishTask = [Task]()
    func getMyPublishTask(_ isFirst:Bool, success:@escaping ((_ result:[Task]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestMyPublishTask()
        request.offset = "\(self.publishTask.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getMyPublishTask(request) { (data) in
            if data.isSuccess()
            {
                var rs = [Task]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = Task(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.publishTask.append(contentsOf: rs)
                if isFirst
                {
                    self.publishTask = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var taskDetail:TaskDetail?
    func getTaskDetail(_ id:String, success:@escaping ((_ result:TaskDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestTaskDetail()
        request.task_id = id
        NetWorkHandle.NetWorkHandleTask.getTaskDetail(request) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let d = TaskDetail(dictionary: data.data as! NSDictionary)
                    self.taskDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    func publishTask(_ task:PublishTask, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestPublishTask()
        request.task_title = task.task_title
        request.task_content = task.task_content
        request.task_end_date = task.task_end_date
        request.assigns = task.assigns
        request.task_projectwork_id = task.task_projectwork_id
//        request.director = task.director
//        request.supporter = task.supporter
        
        NetWorkHandle.NetWorkHandleTask.publishTask(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func finishTask(_ id:String, text:String, photos:[UIImage], files:[String], success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        DispatchQueue.global().async { 
            let request = NetWorkHandle.NetWorkHandleTask.RequestFinishTask()
            request.task_comment = text
            request.task_id = id
            for p in photos
            {
                let photo = NetWorkHandle.NetWorkHandleTask.RequestFinishTaskPhoto()
                photo.photo_suffix = "jpg"
                photo.photo_content = Helper.imageToBase64(p)
                request.photos.append(photo)
            }
            for f in files
            {
                let file = NetWorkHandle.NetWorkHandleTask.RequestFinishTaskFile()
                let s:NSString = f as NSString
                file.file_name = s.lastPathComponent.components(separatedBy: ".")[0]
                file.file_suffix = s.lastPathComponent.components(separatedBy: ".")[1]
                let data:Data = try! Data(contentsOf: URL(fileURLWithPath: f))
                let base = data.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
                file.file_content = base
                request.files.append(file)
            }
            
            NetWorkHandle.NetWorkHandleTask.finishTask(request) { (data) in
                if data.isSuccess()
                {
                    success(data.msg)
                }else{
                    failure(data)
                }
            }
        }
    }
    
    func acceptTask(_ id:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestAcceptTask()
        request.task_id = id
        NetWorkHandle.NetWorkHandleTask.acceptTask(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func assignTask(_ task:PublishTask, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestAssignTask()
        request.task_id = task.taskId
        request.assigns = task.assigns
//        request.director = task.director
//        request.supporter = task.supporter
        NetWorkHandle.NetWorkHandleTask.assignTask(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    var notify = [LeaderActivity]()
    func getTaskNotify(_ isFirst:Bool, key:String? = nil, classify:String?, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestTaskNotify()
        request.offset = "\(self.notify.count)"
        request.row_count = "\(pageSize)"
        request.classify = classify
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getTaskNotifyList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [LeaderActivity]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = LeaderActivity(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.notify.append(contentsOf: rs)
                if isFirst
                {
                    self.notify = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var notifyDetail:LeaderActivityDetail?
    func getTaskNotifyDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestTaskNotifyDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleTask.getTaskNotifyDetail(request) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let d = LeaderActivityDetail(dictionary: data.data as! NSDictionary)
                    self.notifyDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    func publishApprove(_ advice_content:String, advice_type:String, advice_ref_id:String, assigns:String, success:@escaping (() -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestPublishApprove()
        request.advice_content = advice_content
        request.advice_type = advice_type
        request.advice_ref_id = advice_ref_id
        request.assigns = assigns
        NetWorkHandle.NetWorkHandleTask.publishApprove(request) { (data) in
            if data.isSuccess()
            {
                success()
            }else{
                failure(data)
            }
        }
    }
    
    //类型，// 1代表重点项目,2代表动态消息
    var approves = [Approve]()
    func getApprove(_ isFirst:Bool, advice_type:String?, advice_ref_id:String, success:@escaping ((_ result:[Approve]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestGetApproveList()
        request.offset = "\(self.approves.count)"
        request.row_count = "\(pageSize)"
        request.advice_type = advice_type
        request.advice_ref_id = advice_ref_id
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getApproveList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [Approve]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = Approve(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.approves.append(contentsOf: rs)
                if isFirst
                {
                    self.approves = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    //类型，// 1代表重点项目,2代表动态消息
    var myApproves = [Approve]()
    func getMyApprove(_ isFirst:Bool, success:@escaping ((_ result:[Approve]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestMyApproveList()
        request.offset = "\(self.myApproves.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getMyApproveList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [Approve]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = Approve(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.myApproves.append(contentsOf: rs)
                if isFirst
                {
                    self.myApproves = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    //类型，// 1代表重点项目,2代表动态消息
    var myPublishApproves = [Approve]()
    func getMyPublishApprove(_ isFirst:Bool, success:@escaping ((_ result:[Approve]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestMyPublishApproveList()
        request.offset = "\(self.myPublishApproves.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleTask.getMyPublishApproveList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [Approve]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = Approve(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.myPublishApproves.append(contentsOf: rs)
                if isFirst
                {
                    self.myPublishApproves = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    func replyApprove(_ advice_id:String, content:String, success:@escaping (() -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestReplyApprove()
        request.advice_id = advice_id
        request.content = content
        
        NetWorkHandle.NetWorkHandleTask.replyApprove(request) { (data) in
            if data.isSuccess()
            {
                success()
            }else{
                failure(data)
            }
        }
    }
    
    var approveDetail:ApproveDetail?
    func getApproveDetail(_ id:String, success:@escaping ((_ result:ApproveDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestApproveDetail()
        request.advice_id = id
        NetWorkHandle.NetWorkHandleTask.getApproveDetail(request) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let d = ApproveDetail(dictionary: data.data as! NSDictionary)
                    self.approveDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
}
