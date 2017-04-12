//
//  UserDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserDataSource: NSObject {
    
    func getValideCode(_ tel:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestUserValidCode()
        request.mobile = tel
        
        NetWorkHandle.NetWorkHandleUser.getValidCode(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func login(_ tel:String, code:String, success:@escaping ((_ result:UserInfo) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
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
                    let ui = UserInfo(dictionary: dic!)
                    success(ui)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    func getUserDetail(_ id:String, success:@escaping ((_ result:UserInfo) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestGetUserDetail()
        request.id = id
        NetWorkHandle.NetWorkHandleUser.getUserDetail(request) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let ui = UserInfo(dictionary: data.data  as! NSDictionary)
                    success(ui)
                }else{
                
                }
            }else{
                
            }
        }
    }
    
    func getToken(_ success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        NetWorkHandle.NetWorkHandleUser.getToken(nil) { (data) in
            if data.isSuccess()
            {
                if data.data as? NSDictionary != nil
                {
                    let token = (data.data as! NSDictionary).object(forKey: "token") as! String
                    success(token)
                }else{
                    failure(data)
                }
            }else{
                failure(data)
            }
        }
    }
    
    func updateUserToken(_ token:String, success:@escaping ((_ result:String) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestUpdatePushToken()
        request.device_token = token
        NetWorkHandle.NetWorkHandleUser.updatePushToken(request) { (data) in
            if data.isSuccess()
            {
                success(data.msg)
            }else{
                failure(data)
            }
        }
    }
    
    func updateUserPhoto(_ image:UIImage, success:@escaping ((_ result:UserInfo) -> Void), failure:@escaping ((_ error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestUpdateUserPhoto()
        request.photo_suffix = ".jpg"
        request.photo_content = Helper.imageToBase64(image)
        NetWorkHandle.NetWorkHandleUser.updateUserPhoto(request) { (data) in
            if data.isSuccess()
            {
                let user = UserInfo(dictionary: data.data as! NSDictionary)
                success(user)
            }else{
                failure(data)
            }
        }
    }
}
