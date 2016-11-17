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
    
    func getBBSList(isFirst:Bool, success:((result:[BBS]) -> Void), failure:((error:HttpResponseData)->Void))
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
                        let r = BBS.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.bbs.appendContentsOf(rs)
                if isFirst
                {
                    self.bbs = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    var bbsDetail:BBSDetail?
    func getBBSDetail(id:String, success:((result:BBSDetail) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestBBSDetail()
        request.id = id
        NetWorkHandle.NetworkHandleBBS.getBBSDetail(request) { (data) in
            if data.isSuccess()
            {
                let dic = data.data as? NSDictionary
                if dic != nil
                {
                    let bbs = BBSDetail.parse(dict: dic!)
                    self.bbsDetail = bbs
                    success(result: bbs)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
    
    var bbsComment = [BBSComment]()
    func getBBSComment(isFirst:Bool, id:String, success:((result:[BBSComment]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestBBSCommentList()
        request.offset = self.bbsComment.count
        request.row_count = pageSize
        request.exchange_id = id
        if isFirst {
            request.offset = 0
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
                        let r = BBSComment.parse(dict: dic)
                        rs.append(r)
                    }
                }
                self.bbsComment.appendContentsOf(rs)
                if isFirst
                {
                    self.bbsComment = rs
                }
                success(result: rs)
            }else{
                failure(error: data)
            }
        }
    }
    
    func addBBSComment(id:String, content:String, userId:String, replyUserId:String?, success:((result:BBSComment) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetworkHandleBBS.RequestAddBBSComment()
        request.exchange_id = id
        request.publish_user_id = userId
        request.content = content
        request.receiver_user_id = replyUserId == nil ? "" : replyUserId
        NetWorkHandle.NetworkHandleBBS.addBBSComment(request) { (data) in
            if data.isSuccess()
            {
                let c = BBSComment.parse(dict: data.data as! NSDictionary)
                success(result: c)
            }else{
                failure(error: data)
            }
        }
    }
}






