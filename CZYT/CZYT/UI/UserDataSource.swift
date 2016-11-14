//
//  UserDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserDataSource: NSObject {
    
    func getValideCode(tel:String, success:((result:String) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestUserValidCode()
        request.mobile = tel
        
        NetWorkHandle.NetWorkHandleUser.getValidCode(request) { (data) in
            if data.isSuccess()
            {
                success(result: data.msg)
            }else{
                failure(error: data)
            }
        }
    }
    
    func login(tel:String, code:String, success:((result:UserInfo) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestUserLogin()
        request.mobile = tel
        request.validcode = code
        
        NetWorkHandle.NetWorkHandleUser.login(request) { (data) in
            if data.isSuccess()
            {
                let dic = data.data as? NSDictionary
                if dic != nil
                {
                    let ui = UserInfo.parse(dict: dic!)
                    success(result: ui)
                }else{
                    failure(error: data)
                }
            }else{
                failure(error: data)
            }
        }
    }
}
