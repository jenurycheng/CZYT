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
        static var Address_GetUserActivity = "LeaderActivityList?"

        class RequestLeaderActivity : Reflect
        {
            var classify:String?//省级，资阳，成都
            var offset:String?  //0开始
            var row_count:String?
        }
        class func getLeaderActivity(request:RequestLeaderActivity?, finish:((HttpResponseData)->Void)) {
            NetWorkHandle.PublicNetWorkAccess(Address_GetUserActivity, accessType: HttpRequestType.POST, param: request?.toDict(), complete: finish, useCache: false)
        }
    }
}
