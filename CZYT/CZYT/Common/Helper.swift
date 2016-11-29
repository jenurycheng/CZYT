//
//  Helper.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration.CaptiveNetwork

let screen_width = UIScreen.mainScreen().bounds.size.width
let screen_height = UIScreen.mainScreen().bounds.size.height
let max_length = max(screen_width, screen_height)

var IS_IPHONE_4:Bool = (max_length == 480.0)
var IS_IPHONE_5:Bool = (max_length == 568.0)
var IS_IPHONE_6:Bool = (max_length == 667.0)
var IS_IPHONE_6P:Bool = (max_length == 736.0)

var SIZE_SCALE:CGFloat = (IS_IPHONE_4 || IS_IPHONE_5) ? 2.0 : ( IS_IPHONE_6P ? 1.545 : 1.707)

class hotElementInfo{
    var index:Int!
    var text:String!
    var cellIndex:Int! = 0
    var curCellColumn:Int! = 0
    var btnRect:CGRect!
}

class Helper: NSObject {

    class func scaleLogic(origion:CGFloat)->CGFloat
    {
        return origion/SIZE_SCALE
    }
    
    class func scale(origion:CGFloat)->CGFloat
    {
        return origion/SIZE_SCALE/2
    }
    
    class func getTextSize(text:String, font:UIFont, size:CGSize)->CGSize
    {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.UsesLineFragmentOrigin
        let rect:CGRect = text.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    class func parseColor(color:Int64)->UIColor{
        let r = (color&0xFF000000) >> 24
        let g = (color&0x00FF0000) >> 16
        let b = (color&0x0000FF00) >> 8
        let a = (color&0x000000FF)
        
        let color = UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
        
        return color
    }
    
    class func randColor()->UIColor
    {
        //取85-205
        let r = CGFloat((arc4random() % 120)+85)/255.0
        let g = CGFloat((arc4random() % 120)+85)/255.0
        let b = CGFloat((arc4random() % 120)+85)/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
    
    static func isStringEmpty(string:String?)->Bool
    {
        if string == nil || string?.characters.count == 0
        {
            return true
        }
        return false
    }
    
    static func isNetworkAvailable()->Bool
    {
        let manager = NetworkReachabilityManager()
        return manager!.isReachable
    }

    static func imageToBase64(image:UIImage)->String
    {
        let imageData:NSData = UIImageJPEGRepresentation(image, 0.7)!
        return imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
    }
    
    class func getSSID()->String
    {
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = dict["SSID"]!
//                    let mac  = dict["BSSID"]!
                    print(dict)
                    return ssid as! String
                }
            }
        }
        return ""
    }
    
    class func getBSSID()->String
    {
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
//                    let ssid = dict["SSID"]!
                    let mac  = dict["BSSID"]!
                    print(dict)
                    return mac as! String
                }
            }
        }
        return ""
    }
    
    static func getIPAddresses() -> String? {
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr.memory.ifa_next }
                
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        
        return addresses.count > 0 ? addresses[0] : nil
        
    }
    
    static func getLocalIpAddress()->String?
    {
        var localIp:String? = nil
        var addrs:UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&addrs) == 0
        {
            var cursor = addrs
            while cursor != nil {
                if cursor.memory.ifa_addr.memory.sa_family == UInt8(AF_INET) && (Int32(cursor.memory.ifa_flags)&IFF_LOOPBACK) == 0{
                    let addrin:UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>(cursor.memory.ifa_addr)
                    localIp = String(UTF8String: inet_ntoa(addrin.memory.sin_addr))
//                    break
                }
                cursor = cursor.memory.ifa_next
            }
            freeifaddrs(addrs)
        }
        return localIp
    }
    
    static func getOuterIpAddress()->String?
    {
        let host = CFHostCreateWithName(nil,"www.baidu.com").takeRetainedValue()
        CFHostStartInfoResolution(host, .Addresses, nil)
        var success: DarwinBoolean = false
        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
            let theAddress = addresses.firstObject as? NSData {
            var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
            if getnameinfo(UnsafePointer(theAddress.bytes), socklen_t(theAddress.length),
                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                if let numAddress = String.fromCString(hostname) {
                    print(numAddress)
                    return numAddress
                }
            }
        }
        return nil
    }
    
    static func formatDate(date:NSDate, format:String)->String
    {
        let f = NSDateFormatter()
        f.dateFormat = format
        return f.stringFromDate(date)
    }
    
    static func formatDateString(dateString:String, fromFormat:String, toFormat:String)->String
    {
        
        let f = NSDateFormatter()
        f.dateFormat = fromFormat
        let date = f.dateFromString(dateString)
        f.dateFormat = toFormat
        if date != nil
        {
            return f.stringFromDate(date!)
        }else{
            return ""
        }
    }
    
    static func resizeImage(image:UIImage, toSize:CGSize)->UIImage
    {
        var size = toSize
        if size.width == 0
        {
            size.width = 10
        }
        if size.height == 0
        {
            size.height = 10
        }
        UIGraphicsBeginImageContext(size);
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage!;
    }
    
    static func gradientImage(frame:CGRect)->UIImage
    {
        return Helper.imageWithGradientColors([Helper.randColor(), Helper.randColor()], frame: frame)
    }
    
    static func imageWithGradientColors(colors:Array<UIColor>, frame:CGRect)->UIImage
    {
        var array:Array<CGColor> = Array<CGColor>()
        for c in colors
        {
            array.append(c.CGColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context!)
        let colorSpace = CGColorGetColorSpace(array.last!)
        let gradient = CGGradientCreateWithColors(colorSpace, array, nil)
        let start = CGPointMake(0, frame.size.height)
        let end = CGPointMake(frame.size.width, 0)
        CGContextDrawLinearGradient(context!, gradient!, start, end, [.DrawsBeforeStartLocation, .DrawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(context!)
        UIGraphicsEndImageContext()
        
        return image!
    }

    static func imageWithColor(color:UIColor!, size:CGSize, isRetain:Bool = false)->UIImage {
        
        let rect:CGRect = CGRectMake(0, 0, size.width, size.height)
        if isRetain {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        }
        else {
            UIGraphicsBeginImageContext(rect.size)
        }
        
        // UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context!, color.CGColor)
        CGContextFillRect(context!, rect)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    static func imageWithLoading(size:CGSize, str:String="Loading") -> UIImage {
        
//        let rect = CGRectMake(0, 0, size.width, size.height)
//        let label:UILabel = UILabel(frame: rect)
//        label.backgroundColor = Helper.parseColor(0xd9edffff)
//        if str.characters.count > 0 {
//            label.textColor = Helper.parseColor(0x9eadbaff)
//            label.textAlignment = NSTextAlignment.Center
//            let len = CGFloat(str.characters.count)+6
//            //  label.font = UIFont.systemFontOfSize(rect.size.width/len)
//            label.font = UIFont.systemFontOfSize(12.5)
//            label.text = str
//        }
//        
//        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
//        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
        
        var rect = CGRectMake(0, 0, size.width, size.height)
        
        if rect.width == 0
        {
            rect.size.width = 10
        }
        if rect.height == 0
        {
            rect.size.height = 10
        }
        
        let minValue = min(size.height, size.width)
        
        let img = UIImage(named: "loading")
        let imageView = UIImageView(frame: rect)
        imageView.backgroundColor = ThemeManager.current().backgroundColor
        imageView.image = Helper.resizeImage(img!, toSize: CGSizeMake(minValue/2, minValue/2 / img!.size.width * img!.size.height))
        imageView.contentMode = UIViewContentMode.Center
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    static func imageWithString(str:String?, size:CGSize)->UIImage {
        
        var rect = CGRectMake(0, 0, size.width, size.height)
        if rect.width == 0
        {
            rect.size.width = 10
        }
        if rect.height == 0
        {
            rect.size.height = 10
        }
        let label:UILabel = UILabel(frame: rect)
        label.backgroundColor = Helper.parseColor(0xdbdbdbff)
        label.textColor = Helper.parseColor(0xa0a0a0ff)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(size.height/3.9)
        if nil != str && str?.characters.count > 0 {
            let index = str?.startIndex.advancedBy(1)
            let showOneChar = str?.substringToIndex(index!)
            label.text = showOneChar
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func getBundleDisplayName() -> String {
        
        let appName = NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: NSBundle.mainBundle(), value: "", comment: "")
        return appName
    }
    
    class func resultToJsonString(result:Any?)->String
    {
        let data = try? NSJSONSerialization.dataWithJSONObject(result as! AnyObject, options: NSJSONWritingOptions.PrettyPrinted)
        let string = String(data: data!, encoding: NSUTF8StringEncoding)
        return string!
    }
    
    class func getMD5Code(sourceString string:String)->String{
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
