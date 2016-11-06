//
//  NetWorkHandleApp.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension NetWorkHandle
{
    class NetWorkHandleApp: NSObject {
        static var Address_GetAppHome = "/apis/rest/VideoappService/getAppIndex?"
        
        class RequestGetAppHome : Reflect {
            
        }
        
        class func getAppHome(request:RequestGetAppHome?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetAppHome, accessType: HttpRequestType.GET, param: request?.toDict(), complete: finish, useCache: true)
        }
    }
}
