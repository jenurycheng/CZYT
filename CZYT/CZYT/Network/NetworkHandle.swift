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
    
    static var ImageServer:String = "http://image.xgimi.com"
    static var ServerAddress:String = "http://www.yumutech.cn:20080/unity/webservice/ap/"
    
    static var pathNetCache:String! = NSTemporaryDirectory() + "netCache/"
    
    class NetWorkResponse{
        var code:NSNumber?
        var message:String?
        var data:NSDictionary?
    }
    
    class func getImageUrl(urlString:String!)->NSURL
    {
        return NSURL(string: ImageServer+urlString)!
    }
    
//    class func addCommonParam(inout param:NSMutableDictionary)
//    {
//        let date = NSDate()
//        let time = Int64(date.timeIntervalSince1970*1000)
//        let t_ = "\(time)"
//        param.setObject(t_, forKey: "t_")
//        let time_p = Int((time % 10000) * 3 + 2345)
//        let p_ = "\(time_p)"
//        param.setObject(p_, forKey: "p_")
//        param.setObject("2.0", forKey: "v_")
//        param.setObject("com.xgimi.assistant", forKey: "i_")
//        param.setObject("ios", forKey: "d_")
//        param.setObject("9", forKey: "dv_")
        
//        let user = [String:AnyObject]()
//        user["account"] = "unity"
//        user["session"] = "1234567890"
//    }
    
    class func getParam(p:[String:AnyObject]?)->NSMutableDictionary
    {
        let param = NSMutableDictionary()
        
        var user = [String:AnyObject]()
        user["account"] = "unity"
        user["session"] = "1234567890"
        
        let userString = Helper.resultToJsonString(user)
        param.setObject(userString, forKey: "user")
        
        if p != nil
        {
            let dataString = Helper.resultToJsonString(p)
            param.setObject(dataString, forKey: "data")
        }
        
        return param
    }
    
    class func getParamString(param:NSMutableDictionary?)->String
    {
        var paramString = ""
        if param != nil
        {
            for key in param!.allKeys
            {
                if key.isEqual(param!.allKeys.last)
                {
                    paramString += "\(key)=\(param!.objectForKey(key)!)"
                }else{
                    paramString += "\(key)=\(param!.objectForKey(key)!)&"
                }
            }
        }
        return paramString
    }
    
    class func PublicNetWorkAccess(url:String,accessType:HttpRequestType,param:[String:AnyObject]?,complete:((HttpResponseData)->Void), useCache:Bool = false){
        
        func parseSuccess(data:AnyObject)
        {
            print(data.classForCoder)
            var dic:[String : AnyObject]? = nil
            if data.isKindOfClass(NSData) {
                dic = try! NSJSONSerialization.JSONObjectWithData(data as! NSData, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject]
            }else{
                dic = data as? [String : AnyObject]
            }
            
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
        
        func parseFailure(operation:NSURLSessionDataTask?, error:NSError)
        {
            CCPrint(error)
            complete(HttpResponseData(code: HttpResponseData.CODE_SERVER_ERROR, msg: "服务器错误", data: nil))
        }
        
        if useCache {
            let data = NetWorkCache.getTodayCache(url, param: param)
            if data != nil {
                CCPrint("有效当天缓存")
                //延迟0.3s，避免界面未生成
                DispatchAfter(0.3, queue: dispatch_get_main_queue(), block: {
                    parseSuccess(data!)
                })
                
                return
            }
        }
        
        if !Helper.isNetworkAvailable()
        {
            if useCache
            {
                let data = NetWorkCache.getCache(url, param: param)
                if data != nil {
                    CCPrint("有效历史缓存")
                    DispatchAfter(0.3, queue: dispatch_get_main_queue(), block: {
                        parseSuccess(data!)
                    })
                    return
                }
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5)), dispatch_get_main_queue(), { () -> Void in
                complete(HttpResponseData(code: HttpResponseData.CODE_NETWORK_ERROR, msg: "网络异常", data: nil))
            })
            return
        }
        
        let manager:AFHTTPSessionManager = AFHTTPSessionManager.managerSwift() as! AFHTTPSessionManager
//        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
//        manager.requestSerializer.setValue("text/xml", forHTTPHeaderField: "Accept")
        manager.responseSerializer = AFXMLParserResponseSerializer()
        let paramDic:NSMutableDictionary? = self.getParam(param)
        
        let paramString = self.getParamString(paramDic)
        
        CCPrint("\(ServerAddress + url+paramString)")
        
        switch accessType{
        case HttpRequestType.POST:
            manager.POST(ServerAddress + url, parameters: paramDic, success: { (task, result) in
                parseSuccess(result!)
                if useCache
                {
                    let data = try? NSJSONSerialization.dataWithJSONObject(result!, options: .PrettyPrinted)
                    if data != nil
                    {
                        //保存历史缓存
                        NetWorkCache.addCache(url, param: param, data: data)
                        //保存当天缓存
                        NetWorkCache.addTodayCache(url, param: param, data: data)
                    }
                }
                }, failure: { (task, error) in
                    parseFailure(task, error: error)
            })
//            manager.POST(ServerAddress + url, parameters: paramDic, progress: { (progress) in
//                
//                }, success: { (task, result) in
//                    parseSuccess(result!)
//                    if useCache
//                    {
//                        let data = try? NSJSONSerialization.dataWithJSONObject(result!, options: .PrettyPrinted)
//                        if data != nil
//                        {
//                            //保存历史缓存
//                            NetWorkCache.addCache(url, param: param, data: data)
//                            //保存当天缓存
//                            NetWorkCache.addTodayCache(url, param: param, data: data)
//                        }
//                    }
//                }, failure: { (task, error) in
//                    parseFailure(task, error: error)
//            })
        case HttpRequestType.GET:
            manager.GET(ServerAddress + url, parameters: paramDic, progress: { (progress) in
                
                }, success: { (task, result) in
                    parseSuccess(result!)
                    
                    let data = try? NSJSONSerialization.dataWithJSONObject(result!, options: .PrettyPrinted)
                    if data != nil
                    {
                        //保存历史缓存
                        NetWorkCache.addCache(url, param: param, data: data)
                        //保存当天缓存
                        NetWorkCache.addTodayCache(url, param: param, data: data)
                    }
                }, failure: { (task, error) in
                    parseFailure(task, error: error)
            })
        }
    }
}

