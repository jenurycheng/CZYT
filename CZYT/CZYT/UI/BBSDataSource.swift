//
//  BBSDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSDataSource: NSObject {
    
    var bbs = [BBS]()
    var pageSize = 10
    
    func publishBBS(_ title:String, content:String?, success:@escaping (() -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let r = NetWorkHandle.NetworkHandleBBS.RequestAddBBS()
        r.title = title
        r.content = content
        NetWorkHandle.NetworkHandleBBS.addBBS(r) { (data) in
            if data.isSuccess()
            {
                success()
            }else{
                failure(data)
            }
        }
    }
    
    func getBBSList(_ isFirst:Bool, success:@escaping ((_ result:[BBS]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestGetBBSList()
        request.classify = ""
        request.offset = "\(self.bbs.count)"
        request.row_count = "\(pageSize)"
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetworkHandleBBS.getBBSList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [BBS]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = BBS(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.bbs.append(contentsOf: rs)
                if isFirst
                {
                    self.bbs = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    var bbsDetail:BBSDetail?
    func getBBSDetail(_ id:String, success:@escaping ((_ result:BBSDetail) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestBBSDetail()
        request.id = id
        NetWorkHandle.NetworkHandleBBS.getBBSDetail(request) { (data) in
            if data.isSuccess()
            {
                let dic = data.data as? NSDictionary
                if dic != nil
                {
                    let bbs = BBSDetail(dictionary: dic!)
                    self.bbsDetail = bbs
                    success(bbs)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    var bbsComment = [BBSComment]()
    func getBBSComment(_ isFirst:Bool, id:String, success:@escaping ((_ result:[BBSComment]) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestBBSCommentList()
        request.offset = "\(self.bbsComment.count)"
        request.row_count = "\(pageSize)"
        request.exchange_id = id
        if isFirst {
            request.offset = "0"
        }
        
        NetWorkHandle.NetworkHandleBBS.getBBSCommentList(request) { (data) in
            if data.isSuccess()
            {
                var rs = [BBSComment]()
                let ar = data.data as? Array<NSDictionary>
                if ar != nil
                {
                    for dic in ar!
                    {
                        let r = BBSComment(dictionary: dic)
                        rs.append(r)
                    }
                }
                self.bbsComment.append(contentsOf: rs)
                if isFirst
                {
                    self.bbsComment = rs
                }
                success(rs)
            }else{
                failure(data)
            }
        }
    }
    
    func addBBSComment(_ id:String, content:String, userId:String, replyUserId:String?, parent_comment_id:String?, success:@escaping ((_ result:BBSComment) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestAddBBSComment()
        request.exchange_id = id
        request.publish_user_id = userId
        request.content = content
        request.receiver_user_id = replyUserId == nil ? "" : replyUserId
        request.parent_comment_id = parent_comment_id
        NetWorkHandle.NetworkHandleBBS.addBBSComment(request) { (data) in
            if data.isSuccess()
            {
                let c = BBSComment(dictionary: data.data as! NSDictionary)
                success(c)
            }else{
                failure(data)
            }
        }
    }
}






