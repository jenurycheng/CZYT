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
        static var Address_GetBBSList = "ExchangeList?"
        static var Address_GetBBSDetail = "ExchangeItem?"
        static var Address_GetBBSCommentList = "ExchangeCommentList?"
        static var Address_GetBBSAddComment = "ExchangeCommentAdd?"
        
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
        
        class RequestBBSCommentList : Reflect
        {
            var exchange_id:String?
            var offset:Int?
            var row_count:Int?
        }
        
        class func getBBSCommentList(request:RequestBBSCommentList?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSCommentList, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
        
        class RequestAddBBSComment : Reflect
        {
            var exchange_id:String?
            var content:String?
            var publish_user_id:String?
            var receiver_user_id:String?
        }
        
        class func addBBSComment(request:RequestAddBBSComment?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSAddComment, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }

}
