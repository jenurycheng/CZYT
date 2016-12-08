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
    
    var pageSize = 10
    
    func getModelType(type:String, success:((result:[LeaderType]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = LeaderType.parse(dict: dic)
                        rs.append(r)
                    }
                }
                
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    
    var leaderActivity = [LeaderActivity]()
    func getLeaderActivity(isFirst:Bool, classify:String, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestLeaderActivity()
        request.classify = classify
        request.offset = "\(self.leaderActivity.count)"
        request.row_count = "\(pageSize)"
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.leaderActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.leaderActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var leaderActivityDetail:LeaderActivityDetail?
    func getLeaderActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestLeaderActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getLeaderActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.leaderActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var fileActivity = [LeaderActivity]()
    func getFileActivity(isFirst:Bool, classify:String, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestFileActivity()
        request.classify = classify
        request.offset = "\(self.fileActivity.count)"
        request.row_count = "\(pageSize)"
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.fileActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.fileActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var fileActivityDetail:LeaderActivityDetail?
    func getFileActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestFileActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getFileActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.fileActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var workStatusActivity = [LeaderActivity]()
    func getWorkStatusActivity(isFirst:Bool, classify:String, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestWorkStatusActivity()
        request.classify = classify
        request.offset = "\(self.workStatusActivity.count)"
        request.row_count = "\(pageSize)"
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.workStatusActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.workStatusActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var workStatusActivityDetail:LeaderActivityDetail?
    func getWorkStatusActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestWorkStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getWorkStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.workStatusActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var areaStatusActivity = [LeaderActivity]()
    func getAreaStatusActivity(isFirst:Bool, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.areaStatusActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.areaStatusActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var areaActivityDetail:LeaderActivityDetail?
    func getAreaActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestAreaStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getAreaStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.areaActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var departStatusActivity = [LeaderActivity]()
    func getDepartStatusActivity(isFirst:Bool, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.departStatusActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.departStatusActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var departActivityDetail:LeaderActivityDetail?
    func getDepartActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestDepartStatusActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getDepartStatusActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.departActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var projectWorkActivity = [LeaderActivity]()
    func getProjectWorkActivity(isFirst:Bool, classify:String, success:((result:[LeaderActivity]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestProjectWorkActivity()
        request.classify = classify
        request.offset = "\(self.projectWorkActivity.count)"
        request.row_count = "\(pageSize)"
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
                        let r = LeaderActivity.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.projectWorkActivity.appendContentsOf(rs)
                if isFirst
                {
                    self.projectWorkActivity = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var projectWorkActivityDetail:LeaderActivityDetail?
    func getProjectWorkActivityDetail(id:String, success:((result:LeaderActivityDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleApp.RequestProjectWorkActivityDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleApp.getProjectWorkActivityDetail(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? NSDictionary
                if r != nil
                {
                    let d = LeaderActivityDetail.parse(dict: r!)
                    self.projectWorkActivityDetail = d
                    success(result: d)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var webLinks = [WebLink]()
    func getWebLink(success:((result:[WebLink]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = WebLink.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.webLinks = rs
                
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
}
