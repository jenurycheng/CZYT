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
        static var Address_AddBBS = "PublishExchange"
        static var Address_GetBBSList = "ExchangeList?"
        static var Address_GetBBSDetail = "ExchangeItem?"
        static var Address_GetBBSCommentList = "ExchangeCommentList?"
        static var Address_GetBBSAddComment = "ExchangeCommentAdd?"
        
        class RequestAddBBS : EVObject
        {
            var title:String?
            var summary:String?
            var content:String?
        }
        
        class func addBBS(_ request:RequestAddBBS?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_AddBBS, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestGetBBSList : EVObject
        {
            var classify = ""
            var offset:String?
            var row_count:String?
        }
        
        class func getBBSList(_ request:RequestGetBBSList?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestBBSDetail : EVObject
        {
            var id:String?
        }
        
        class func getBBSDetail(_ request:RequestBBSDetail?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSDetail, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestBBSCommentList : EVObject
        {
            var exchange_id:String?
            var offset:String?
            var row_count:String?
        }
        
        class func getBBSCommentList(_ request:RequestBBSCommentList?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSCommentList, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
        
        class RequestAddBBSComment : EVObject
        {
            var exchange_id:String?
            var content:String = ""
            var publish_user_id:String?
            var receiver_user_id:String?
            var parent_comment_id:String?
        }
        
        class func addBBSComment(_ request:RequestAddBBSComment?, finish:@escaping ((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetBBSAddComment, accessType: HttpRequestType.POST, param: request?.toDictionary(), complete: finish, useCache: false)
        }
    }

}
