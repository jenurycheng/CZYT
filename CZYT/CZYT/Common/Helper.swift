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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


let screen_width = UIScreen.main.bounds.size.width
let screen_height = UIScreen.main.bounds.size.height
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

    class func scaleLogic(_ origion:CGFloat)->CGFloat
    {
        return origion/SIZE_SCALE
    }
    
    class func scale(_ origion:CGFloat)->CGFloat
    {
        return origion/SIZE_SCALE/2
    }
    
    class func getTextSize(_ text:String, font:UIFont, size:CGSize)->CGSize
    {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    class func parseColor(_ color:Int64)->UIColor{
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
    
    static func isStringEmpty(_ string:String?)->Bool
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

    static func imageToBase64(_ image:UIImage)->String
    {
        let imageData:Data = UIImageJPEGRepresentation(image, 0.7)!
        return imageData.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
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
    
//    static func getIPAddresses() -> String? {
//        var addresses = [String]()
//        
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&ifaddr) == 0 {
//            
//            // For each interface ...
//            var ptr = ifaddr
//            while ptr != nil {
//                defer { ptr = ptr?.pointee.ifa_next }
//                
//                let flags = Int32(ptr?.pointee.ifa_flags)
//                var addr = ptr?.pointee.ifa_addr.pointee
//                
//                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
//                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
//                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
//                        
//                        // Convert interface address to a human readable string:
//                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
//                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
//                            if let address = String(validatingUTF8: hostname) {
//                                addresses.append(address)
//                            }
//                        }
//                    }
//                }
//            }
//            freeifaddrs(ifaddr)
//        }
//        
//        return addresses.count > 0 ? addresses[0] : nil
//        
//    }
    
//    static func getLocalIpAddress()->String?
//    {
//        var localIp:String? = nil
//        var addrs:UnsafeMutablePointer<ifaddrs>? = nil
//        if getifaddrs(&addrs) == 0
//        {
//            var cursor = addrs
//            while cursor != nil {
//                if cursor?.pointee.ifa_addr.pointee.sa_family == UInt8(AF_INET) && (Int32(cursor.pointee.ifa_flags)&IFF_LOOPBACK) == 0{
//                    let addrin:UnsafeMutablePointer<sockaddr_in> = UnsafeMutablePointer<sockaddr_in>(cursor!.pointee.ifa_addr)
//                    localIp = String(validatingUTF8: inet_ntoa(addrin.pointee.sin_addr))
////                    break
//                }
//                cursor = cursor?.pointee.ifa_next
//            }
//            freeifaddrs(addrs)
//        }
//        return localIp
//    }
//    
//    static func getOuterIpAddress()->String?
//    {
//        let host = CFHostCreateWithName(nil,"www.baidu.com" as CFString).takeRetainedValue()
//        CFHostStartInfoResolution(host, .addresses, nil)
//        var success: DarwinBoolean = false
//        if let addresses = CFHostGetAddressing(host, &success)?.takeUnretainedValue() as NSArray?,
//            let theAddress = addresses.firstObject as? Data {
//            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//            if getnameinfo((theAddress as NSData).bytes.bindMemory(to: sockaddr.self, capacity: theAddress.count), socklen_t(theAddress.count),
//                           &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
//                if let numAddress = String(validatingUTF8: hostname) {
//                    print(numAddress)
//                    return numAddress
//                }
//            }
//        }
//        return nil
//    }
    
    static func formatDate(_ date:Date, format:String)->String
    {
        let f = DateFormatter()
        f.dateFormat = format
        return f.string(from: date)
    }
    
    static func formatDateString(_ dateString:String, fromFormat:String, toFormat:String)->String
    {
        
        let f = DateFormatter()
        f.dateFormat = fromFormat
        let date = f.date(from: dateString)
        f.dateFormat = toFormat
        if date != nil
        {
            return f.string(from: date!)
        }else{
            return ""
        }
    }
    
    static func resizeImage(_ image:UIImage, toSize:CGSize)->UIImage
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
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage!;
    }
    
    static func gradientImage(_ frame:CGRect)->UIImage
    {
        return Helper.imageWithGradientColors([Helper.randColor(), Helper.randColor()], frame: frame)
    }
    
    static func imageWithGradientColors(_ colors:Array<UIColor>, frame:CGRect)->UIImage
    {
        var array:Array<CGColor> = Array<CGColor>()
        for c in colors
        {
            array.append(c.cgColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        let colorSpace = array.last!.colorSpace
        let gradient = CGGradient(colorsSpace: colorSpace, colors: array as CFArray, locations: nil)
        let start = CGPoint(x: 0, y: frame.size.height)
        let end = CGPoint(x: frame.size.width, y: 0)
        context!.drawLinearGradient(gradient!, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context!.restoreGState()
        UIGraphicsEndImageContext()
        
        return image!
    }

    static func imageWithColor(_ color:UIColor!, size:CGSize, isRetain:Bool = false)->UIImage {
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        if isRetain {
            UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        }
        else {
            UIGraphicsBeginImageContext(rect.size)
        }
        
        // UIGraphicsBeginImageContextWithOptions(rect.size, true, UIScreen.mainScreen().scale)
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    static func imageWithLoading(_ size:CGSize, str:String="Loading") -> UIImage {
        
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
        
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        if rect.width == 0
        {
            rect.size.width = 10
        }
        if rect.height == 0
        {
            rect.size.height = 10
        }
        
//        let minValue = min(size.height, size.width)
        
//        let img = UIImage(named: "loading")
        let imageView = UIImageView(frame: rect)
        imageView.backgroundColor = ThemeManager.current().backgroundColor
//        imageView.image = Helper.resizeImage(img!, toSize: CGSizeMake(minValue/2, minValue/2 / img!.size.width * img!.size.height))
        imageView.contentMode = UIViewContentMode.center
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    static func imageWithString(_ str:String?, size:CGSize)->UIImage {
        
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
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
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: size.height/3.9)
        if nil != str && str?.characters.count > 0 {
            let index = str?.characters.index((str?.startIndex)!, offsetBy: 1)
            let showOneChar = str?.substring(to: index!)
            label.text = showOneChar
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    class func getBundleDisplayName() -> String {
        
        let appName = NSLocalizedString("CFBundleDisplayName", tableName: "InfoPlist", bundle: Bundle.main, value: "", comment: "")
        return appName
    }
    
    class func resultToJsonString(_ result:Any?)->String
    {
        let data = try? JSONSerialization.data(withJSONObject: result as! AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted)
        let string = String(data: data!, encoding: String.Encoding.utf8)
        return string!
    }
    
    class func getMD5Code(sourceString string:String)->String{
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
