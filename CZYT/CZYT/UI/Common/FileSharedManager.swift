//
//  FileSharedManager.swift
//  GiMiHelper_3_0
//
//  Created by 成超 on 11/1/16.
//  Copyright © 2016 shuaidan. All rights reserved.
//

import UIKit

class DocumentFile
{
    var path:String?
    var name:String?
    var size:Int?
}

class DocumentDir
{
    var typeName:String?
    var files:[DocumentFile]?
}

class FileSharedManager: NSObject {
    static var singleTon:FileSharedManager?
    
    static var PATH_SHARED_FILE = NSTemporaryDirectory() + "sharedFile/"
    static var PATH_SHARED_TXT = PATH_SHARED_FILE + "txt/"
    static var PATH_SHARED_DOC = PATH_SHARED_FILE + "doc/"
    static var PATH_SHARED_PPT = PATH_SHARED_FILE + "ppt/"
    static var PATH_SHARED_XLS = PATH_SHARED_FILE + "xls/"
    static var PATH_SHARED_PDF = PATH_SHARED_FILE + "pdf/"
    static var PATH_SHARED_APK = PATH_SHARED_FILE + "apk/"
    static var PATH_SHARED_OTHER = PATH_SHARED_FILE + "other/"
    
    class func sharedManager()->FileSharedManager
    {
        if singleTon == nil {
            singleTon = FileSharedManager()
        }
        return singleTon!
    }
    
    var queue = dispatch_queue_create("file_shared_manager", DISPATCH_QUEUE_SERIAL)
    
    private func createPath(path:String)
    {
        if (!NSFileManager.defaultManager().fileExistsAtPath(path))
        {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func wirteToFile(url:NSURL, callback:((b:Bool, msg:String?)->Void)?)
    {
        dispatch_async(queue) { 
            var fileName = url.absoluteString.componentsSeparatedByString("/").last
            if fileName == nil
            {
                return
            }
            fileName = fileName!.stringByRemovingPercentEncoding
            do{
            
                if fileName!.contain(subStr: "txt") || fileName!.contain(subStr: "TXT") {
                    self.createPath(FileSharedManager.PATH_SHARED_TXT)
                    let path = FileSharedManager.PATH_SHARED_TXT + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else if fileName!.contain(subStr: ".doc") || fileName!.contain(subStr: ".DOC")
                {
                    self.createPath(FileSharedManager.PATH_SHARED_DOC)
                    let path = FileSharedManager.PATH_SHARED_DOC + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else if fileName!.contain(subStr: ".ppt") || fileName!.contain(subStr: ".PPT")
                {
                    self.createPath(FileSharedManager.PATH_SHARED_PPT)
                    let path = FileSharedManager.PATH_SHARED_PPT + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else if fileName!.contain(subStr: ".xls") || fileName!.contain(subStr: ".XLS")
                {
                    self.createPath(FileSharedManager.PATH_SHARED_XLS)
                    let path = FileSharedManager.PATH_SHARED_XLS + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else if fileName!.contain(subStr: ".pdf") || fileName!.contain(subStr: ".PDF")
                {
                    self.createPath(FileSharedManager.PATH_SHARED_PDF)
                    let path = FileSharedManager.PATH_SHARED_PDF + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else if fileName!.contain(subStr: ".apk") || fileName!.contain(subStr: ".APK")
                {
                    self.createPath(FileSharedManager.PATH_SHARED_APK)
                    let path = FileSharedManager.PATH_SHARED_APK + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }else{
                    self.createPath(FileSharedManager.PATH_SHARED_OTHER)
                    let path = FileSharedManager.PATH_SHARED_OTHER + fileName!
                    let data = NSData(contentsOfURL: url)
                    try data?.writeToFile(path, options: NSDataWritingOptions.AtomicWrite)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if callback != nil
                    {
                        callback!(b: true, msg: "")
                    }
                })
            }
            catch{
                if callback != nil
                {
                    callback!(b: false, msg:"write to file failure")
                }
            }
        }
    }
    
    func getFileAtPath(path:String)->[DocumentFile]
    {
        var files = [DocumentFile]()
        do{
            let array = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(path)
            for name in array
            {
                let info = try? NSFileManager.defaultManager().attributesOfItemAtPath(path + name)
                var size = 0
                if info != nil
                {
                    size = info!["NSFileSize"] as! Int
                }
                let file = DocumentFile()
                file.name = name
                file.path = path + name
                file.size = size
                files.append(file)
                CCPrint(name)
            }
        }catch{
            
        }
        return files
    }
    
    func getAllFile()->[DocumentDir]
    {
        var dirs = [DocumentDir]()
        let types:[(name:String, path:String)] = [("apk", FileSharedManager.PATH_SHARED_APK),
                                                  ("pdf", FileSharedManager.PATH_SHARED_PDF),
                                                  ("ppt", FileSharedManager.PATH_SHARED_PPT),
                                                  ("xls", FileSharedManager.PATH_SHARED_XLS),
                                                  ("doc", FileSharedManager.PATH_SHARED_DOC),
                                                  ("txt", FileSharedManager.PATH_SHARED_TXT),
                                                  ("其它", FileSharedManager.PATH_SHARED_OTHER)]
        for type in types
        {
            let files = self.getFileAtPath(type.path)
            if files.count > 0 {
                let d = DocumentDir()
                d.typeName = type.name
                d.files = files
                dirs.append(d)
            }
        }
        return dirs
    }
}
