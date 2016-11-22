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
    func getMyTask(isFirst:Bool, success:((result:[Task]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = Task.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.myTask.appendContentsOf(rs)
                if isFirst
                {
                    self.myTask = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var publishTask = [Task]()
    func getMyPublishTask(isFirst:Bool, success:((result:[Task]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = Task.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.publishTask.appendContentsOf(rs)
                if isFirst
                {
                    self.publishTask = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var taskDetail:TaskDetail?
    func getTaskDetail(id:String, success:((result:TaskDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestTaskDetail()
        request.task_id = id
        NetWorkHandle.NetWorkHandleTask.getTaskDetail(request) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let d = TaskDetail.parse(dict: data.data as! NSDictionary)
                    self.taskDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    func publishTask(task:PublishTask, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestPublishTask()
        request.task_title = task.task_title
        request.task_content = task.task_content
        request.task_end_date = task.task_end_date
        request.director = task.director
        request.supporter = task.supporter
        
        NetWorkHandle.NetWorkHandleTask.publishTask(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func finishTask(id:String, text:String, photos:[UIImage], success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
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
            NetWorkHandle.NetWorkHandleTask.finishTask(request) { (data) in
                if data.isSuccess()
                {
                    success(result: data.msg)
                }else{
                    failure(error: data)
                }
            }
        }
    }
    
    func acceptTask(id:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleTask.RequestAcceptTask()
        request.task_id = id
        NetWorkHandle.NetWorkHandleTask.acceptTask(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
}
