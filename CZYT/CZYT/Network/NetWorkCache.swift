//
//  NetWorkCache.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class NetWorkCache: NSObject {
    
    static var pathNetCache:String! = NSTemporaryDirectory() + "netCache/"
    
    class func clearCache()
    {
        let path = NetWorkCache.pathNetCache
        
        let fileManager = NSFileManager.defaultManager()
        let _ = try? fileManager.removeItemAtPath(path)
    }
    
    class func createCacheDir()
    {
        let prePath = NetWorkCache.pathNetCache
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(prePath))
        {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(prePath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    class func getSavePath(url:String, param:[String:AnyObject]?)->String
    {
        let paramString = "" + NetWorkCache.getParamString(param) //创建公共参数前的字符串
        
        var path = url + paramString
        
        path = self.formatSavePath(path)
        
        let savePath = NetWorkCache.pathNetCache + path
        
        return savePath
    }
    
    class func getCache(url:String, param:[String:AnyObject]?)->NSData?
    {
        self.createCacheDir()
        
        let savePath = getSavePath(url, param: param)
        
        let data = NSData(contentsOfFile: savePath)
        if data != nil
        {
            return data
        }
        
        return nil
    }
    
    class func getTodayCache(url:String, param:[String:AnyObject]?)->NSData?
    {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.stringFromDate(NSDate())
        
        return NetWorkCache.getCache(dateString + url, param: param)
    }
    
    class func addCache(url:String, param:[String:AnyObject]?, data:NSData?)
    {
        if data == nil
        {
            return
        }
        
        self.createCacheDir()
        
        let savePath = NetWorkCache.getSavePath(url, param: param)
        
        data?.writeToFile(savePath, atomically: true)
    }
    
    class func addTodayCache(url:String, param:[String:AnyObject]?, data:NSData?)
    {
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.stringFromDate(NSDate())
        
        self.addCache(dateString + url, param: param, data: data)
    }
    
    class func getParamString(param:[String:AnyObject]?)->String
    {
        var paramString = ""
        
        if param != nil {
            for key in param!
            {
                paramString += "\(key.0)=\(key.1)&"
            }
        }
        if paramString.characters.count > 0 {
            paramString = paramString.substringToIndex(paramString.endIndex.advancedBy(-1))
        }
        return paramString
    }
    
    class func formatSavePath(path:String)->String
    {
        var desPath = path;
        desPath = desPath.replacingOccurrencesOfString(" ", withString: "")
        desPath = desPath.replacingOccurrencesOfString(",", withString: "")
        desPath = desPath.replacingOccurrencesOfString("/", withString: "")
        desPath = desPath.replacingOccurrencesOfString("\\", withString: "")
        desPath = desPath.replacingOccurrencesOfString("&", withString: "")
        desPath = desPath.replacingOccurrencesOfString("?", withString: "")
        desPath = desPath.replacingOccurrencesOfString(":", withString: "")
        desPath = desPath.replacingOccurrencesOfString("=", withString: "")
        
        return NetWorkCache.getMD5String(sourceString: desPath)
    }
    
    class func getMD5String(sourceString string:String)->String{
        let str = string.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CUnsignedInt(string.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        return String(format: hash as String)
    }
}
