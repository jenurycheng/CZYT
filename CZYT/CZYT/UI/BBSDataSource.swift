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
}
