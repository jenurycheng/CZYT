//
//  NetworkHandle.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

import Foundation


enum HttpRequestType : String{
    case POST = "POST"
    case GET = "GET"
}

class HttpResponseData : NSObject
{
    var code:String! = "-1"
    var msg:String! = "连接超时"
    var data:AnyObject?
    
    static var CODE_NETWORK_ERROR = "-100"
    static var CODE_SESSION_EXPIRE = "-8"
    static var CODE_SERVER_ERROR = "-9"
    static var CODE_SUCCESS:String = "0"

    static var KEY_STATUS = "status"
    static var KEY_CODE = "code"
    static var KEY_MSG = "message"
    static var KEY_DATA = "data"
    
    init(code:String?, msg:String?, data:AnyObject? = nil)
    {
        super.init()
        self.code = code
        self.msg = msg
        self.data = data
    }
    
    func isSuccess()->Bool
    {
        if code == HttpResponseData.CODE_SUCCESS
        {
            return true
        }
        return false
    }
}

class NetWorkHandle: NSObject {
    
//    static var ServerAddress:String = "http://111.9.93.229:20080/unity/webservice/ap/"
    static var ServerAddress:String = "http://182.254.167.232:20080/unity/webservice/ap/"//test
    
//    static var ServerAddress:String = "http://222.18.162.136:8080/unity/webservice/ap/"
    
    static var pathNetCache:String! = NSTemporaryDirectory() + "netCache/"
    
    class NetWorkResponse{
        var code:NSNumber?
        var message:String?
        var data:NSDictionary?
    }
    
    class func getParam(_ p:[String:AnyObject]?)->NSMutableDictionary
    {
        let param = NSMutableDictionary()
        
        var user = [String:AnyObject]()
        user["account"] = UserInfo.sharedInstance.id as AnyObject
        user["session"] = UserInfo.sharedInstance.session as AnyObject
        
        param.setObject(user, forKey: "user" as NSCopying)
        
        if p != nil
        {
            param.setObject(p!, forKey: "data" as NSCopying)
        }
        
        var paramString = Helper.resultToJsonString(param)
        paramString = paramString.replacingOccurrences(of: "\\n", with: "\n")
        let resultDic = NSMutableDictionary(object: paramString, forKey: "req" as NSCopying)
        
        return resultDic
    }
    
    class func getParamString(_ param:NSMutableDictionary?)->String
    {
        var paramString = ""
        if param != nil
        {
            for key in param!.allKeys
            {
                if (key as AnyObject).isEqual(param!.allKeys.last)
                {
                    paramString += "\(key)=\(param!.object(forKey: key)!)"
                }else{
                    paramString += "\(key)=\(param!.object(forKey: key)!)&"
                }
            }
        }
        return paramString
    }
    
    class func PublicNetWorkAccess(_ url:String,accessType:HttpRequestType,param:NSDictionary?,complete:@escaping ((HttpResponseData)->Void), useCache:Bool = false){
        
        func parseSuccess(_ data:AnyObject)
        {
            var dic:[String : AnyObject]? = nil
            
//            if data.isKind(of: ) {
//                dic = try! JSONSerialization.jsonObject(with: data as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
//            }else{
                dic = data as? [String : AnyObject]
//            }
            print(Helper.resultToJsonString(dic))
            var statusDic = dic![HttpResponseData.KEY_STATUS] as? [String : AnyObject]
            var code = statusDic![HttpResponseData.KEY_CODE] as? String
            var msg = statusDic![HttpResponseData.KEY_MSG] as? String
            
            let data = dic![HttpResponseData.KEY_DATA]
            
            if code == nil
            {
                code = "-1"
            }
            
            if Helper.isStringEmpty(msg)
            {
                msg = "服务器错误"
            }
            complete(HttpResponseData(code: code, msg: msg, data: data))
        }
        
        func parseFailure(_ operation:URLSessionDataTask?, error:NSError)
        {
            CCPrint(error)
            complete(HttpResponseData(code: HttpResponseData.CODE_SERVER_ERROR, msg: "服务器错误", data: nil))
        }
        
        if useCache {
            let data = NetWorkCache.getTodayCache(url, param: param as? [String : AnyObject])
            if data != nil {
                CCPrint("有效当天缓存")
                //延迟0.3s，避免界面未生成
                DispatchAfter(0.3, queue: DispatchQueue.main, block: {
                    parseSuccess(data! as AnyObject)
                })
                
                return
            }
        }
        
        if !Helper.isNetworkAvailable()
        {
            if useCache
            {
                let data = NetWorkCache.getCache(url, param: param as? [String : AnyObject])
                if data != nil {
                    CCPrint("有效历史缓存")
                    DispatchAfter(0.3, queue: DispatchQueue.main, block: {
                        parseSuccess(data! as AnyObject)
                    })
                    return
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.5)) / Double(NSEC_PER_SEC), execute: { () -> Void in
                complete(HttpResponseData(code: HttpResponseData.CODE_NETWORK_ERROR, msg: "网络异常", data: nil))
            })
            return
        }
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager.managerSwift() as! AFHTTPSessionManager
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let paramDic:NSMutableDictionary? = self.getParam(param as? [String : AnyObject])
        
//        let paramString = self.getParamString(paramDic)
        
//        CCPrint("\(ServerAddress + url+paramString)")
        
        switch accessType{
        case HttpRequestType.POST:
            manager.post(ServerAddress + url, parameters: paramDic, progress: { (progress) in
                
                }, success: { (task, result) in
                    parseSuccess(result! as AnyObject)
                    if useCache
                    {
                        let data = try? JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                        if data != nil
                        {
                            //保存历史缓存
                            NetWorkCache.addCache(url, param: param as? [String : AnyObject], data: data)
                            //保存当天缓存
                            NetWorkCache.addTodayCache(url, param: param as? [String : AnyObject], data: data)
                        }
                    }
                }, failure: { (task, error) in
                    parseFailure(task, error: error)
            } as? (URLSessionDataTask?, Error) -> Void)
        case HttpRequestType.GET:
            manager.get(ServerAddress + url, parameters: paramDic, progress: { (progress) in
                
                }, success: { (task, result) in
                    parseSuccess(result! as AnyObject)
                    
                    let data = try? JSONSerialization.data(withJSONObject: result!, options: .prettyPrinted)
                    if data != nil
                    {
                        //保存历史缓存
                        NetWorkCache.addCache(url, param: param as? [String : AnyObject], data: data)
                        //保存当天缓存
                        NetWorkCache.addTodayCache(url, param: param as? [String : AnyObject], data: data)
                    }
                }, failure: { (task, error) in
                    parseFailure(task, error: error)
            } as? (URLSessionDataTask?, Error) -> Void)
        }
    }
}

