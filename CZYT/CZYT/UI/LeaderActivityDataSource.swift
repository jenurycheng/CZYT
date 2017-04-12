//
//  LeaderActivityDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivityDataSource: NSObject {
    
    static let Type_LeaderActivity = "LeaderActivity"
    static let Type_PolicyFile = "PolicyFile"
    static let Type_WorkStatus = "WorkStatus"
    static let Type_ProjectWork = "ProjectWork"
    static let Type_BBSList = "Exchange"
    static let Type_TaskNotify = "TaskNotification"
    
    var pageSize = 10
    
    func getModelType(_ type:String, success:@escaping ((_ result:[LeaderType]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestModuleType()
        request.classify = type
        
        NetWorkHandle.NetWorkHandleApp.getModuleType(request) { (data) in
            if data.isSuccess()
            {
                var rs = [LeaderType]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = LeaderType(dictionary: dic)
                        rs.append(r)
                    }
                }
                
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var homeActivity = [LeaderActivity]()
    func getHomeActivity(_ success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestHomeActivity()
        request.row_count = "\(pageSize)"
        request.offset = "0"
        
        NetWorkHandle.NetWorkHandleApp.getHomeActivity(request) { (data) in
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
                self.homeActivity.append(contentsOf: rs)

                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    
    var leaderActivity = [LeaderActivity]()
    func getLeaderActivity(_ isFirst:Bool, classify:String, key:String? = nil, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestLeaderActivity()
        request.classify = classify
        request.offset = "\(self.leaderActivity.count)"
        request.row_count = "\(pageSize)"
        request.key = key
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getLeaderActivity(request) { (data) in
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
                self.leaderActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.leaderActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var leaderActivityDetail:LeaderActivityDetail?
    func getLeaderActivityDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestLeaderActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getLeaderActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail(dictionary: r!)
                    self.leaderActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var fileActivity = [LeaderActivity]()
    func getFileActivity(_ isFirst:Bool, classify:String, key:String? = nil, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestFileActivity()
        request.classify = classify
        request.offset = "\(self.fileActivity.count)"
        request.row_count = "\(pageSize)"
        request.key = key
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getFileActivity(request) { (data) in
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
                self.fileActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.fileActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var fileActivityDetail:LeaderActivityDetail?
    func getFileActivityDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestFileActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getFileActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail(dictionary: r!)
                    self.fileActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var workStatusActivity = [LeaderActivity]()
    func getWorkStatusActivity(_ isFirst:Bool, classify:String, key:String? = nil, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestWorkStatusActivity()
        request.classify = classify
        request.offset = "\(self.workStatusActivity.count)"
        request.row_count = "\(pageSize)"
        request.key = key
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getWorkStatusActivity(request) { (data) in
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
                self.workStatusActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.workStatusActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var workStatusActivityDetail:LeaderActivityDetail?
    func getWorkStatusActivityDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestWorkStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getWorkStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail(dictionary: r!)
                    self.workStatusActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var areaStatusActivity = [LeaderActivity]()
    func getAreaStatusActivity(_ isFirst:Bool, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestAreaStatusActivity()
        request.offset = "\(self.areaStatusActivity.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getAreaStatusActivity(request) { (data) in
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
                self.areaStatusActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.areaStatusActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var areaActivityDetail:LeaderActivityDetail?
    func getAreaActivityDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestAreaStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getAreaStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail(dictionary: r!)
                    self.areaActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var departStatusActivity = [LeaderActivity]()
    func getDepartStatusActivity(_ isFirst:Bool, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestDepartStatusActivity()
        request.offset = "\(self.departStatusActivity.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getDepartStatusActivity(request) { (data) in
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
                self.departStatusActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.departStatusActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var departActivityDetail:LeaderActivityDetail?
    func getDepartActivityDetail(_ id:String, success:@escaping ((_ result:LeaderActivityDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestDepartStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getDepartStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail(dictionary: r!)
                    self.departActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var projectWorkActivity = [LeaderActivity]()
    func getProjectWorkActivity(_ isFirst:Bool, classify:String, key:String? = nil, success:@escaping ((_ result:[LeaderActivity]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestProjectWorkActivity()
        request.classify = classify
        request.offset = "\(self.projectWorkActivity.count)"
        request.row_count = "\(pageSize)"
        request.key = key
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetWorkHandleApp.getProjectWorkActivity(request) { (data) in
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
                self.projectWorkActivity.append(contentsOf: rs)
                if isFirst
                {
                    self.projectWorkActivity = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var projectWorkActivityDetail:ProjectWorkDetail?
    func getProjectWorkActivityDetail(_ id:String, success:@escaping ((_ result:ProjectWorkDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestProjectWorkActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getProjectWorkActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = ProjectWorkDetail(dictionary: r!)
                    self.projectWorkActivityDetail = d
                    success(d)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var webLinks = [WebLink]()
    func getWebLink(_ success:@escaping ((_ result:[WebLink]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestWebLink()
        NetWorkHandle.NetWorkHandleApp.getWebLink(request) { (data) in
            if data.isSuccess()
            {
                var rs = [WebLink]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = WebLink(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.webLinks = rs
                
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
}
