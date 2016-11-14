//
//  NetworkHandleBBS.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle
{
    class NetworkHandleBBS: NSObject {
        static var Address_GetBBSList = "ExchangeList"
        static var Address_GetBBSDetail = "ExchangeItem"
        
        class RequestGetBBSList : Reflect
        {
            var classify = ""
            var offset:String?
            var row_count:String?
        }
        
        class func getBBSList(request:RequestGetBBSList?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSList, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestBBSDetail : Reflect
        {
            var id:String?
        }
        
        class func getBBSDetail(request:RequestBBSDetail?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSDetail, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }

}
