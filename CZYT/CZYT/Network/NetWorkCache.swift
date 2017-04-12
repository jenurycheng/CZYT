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
        
        let fileManager = FileManager.default
        let _ = try? fileManager.removeItem(atPath: path!)
    }
    
    class func createCacheDir()
    {
        let prePath = NetWorkCache.pathNetCache
        
        if (!FileManager.default.fileExists(atPath: prePath!))
        {
            let _ = try? FileManager.default.createDirectory(atPath: prePath!, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    class func getSavePath(_ url:String, param:[String:AnyObject]?)->String
    {
        let paramString = "" + NetWorkCache.getParamString(param) //创建公共参数前的字符串
        
        var path = url + paramString
        
        path = self.formatSavePath(path)
        
        let savePath = NetWorkCache.pathNetCache + path
        
        return savePath
    }
    
    class func getCache(_ url:String, param:[String:AnyObject]?)->Data?
    {
        self.createCacheDir()
        
        let savePath = getSavePath(url, param: param)
        
        let data = try? Data(contentsOf: URL(fileURLWithPath: savePath))
        if data != nil
        {
            return data
        }
        
        return nil
    }
    
    class func getTodayCache(_ url:String, param:[String:AnyObject]?)->Data?
    {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: Date())
        
        return NetWorkCache.getCache(dateString + url, param: param)
    }
    
    class func addCache(_ url:String, param:[String:AnyObject]?, data:Data?)
    {
        if data == nil
        {
            return
        }
        
        self.createCacheDir()
        
        let savePath = NetWorkCache.getSavePath(url, param: param)
        
        try? data?.write(to: URL(fileURLWithPath: savePath), options: [.atomic])
    }
    
    class func addTodayCache(_ url:String, param:[String:AnyObject]?, data:Data?)
    {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: Date())
        
        self.addCache(dateString + url, param: param, data: data)
    }
    
    class func getParamString(_ param:[String:AnyObject]?)->String
    {
        var paramString = ""
        
        if param != nil {
            for key in param!
            {
                paramString += "\(key.0)=\(key.1)&"
            }
        }
        if paramString.characters.count > 0 {
            paramString = paramString.substring(to: paramString.characters.index(paramString.endIndex, offsetBy: -1))
        }
        return paramString
    }
    
    class func formatSavePath(_ path:String)->String
    {
        var desPath = path;
        desPath = desPath.replacingOccurrences(of:" ", with: "")
        desPath = desPath.replacingOccurrences(of:",", with: "")
        desPath = desPath.replacingOccurrences(of:"/", with: "")
        desPath = desPath.replacingOccurrences(of:"\\", with: "")
        desPath = desPath.replacingOccurrences(of:"&", with: "")
        desPath = desPath.replacingOccurrences(of:"?", with: "")
        desPath = desPath.replacingOccurrences(of:":", with: "")
        desPath = desPath.replacingOccurrences(of:"=", with: "")
        
        return NetWorkCache.getMD5String(sourceString: desPath)
    }
    
    class func getMD5String(sourceString string:String)->String{
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}
