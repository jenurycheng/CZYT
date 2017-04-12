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
    
    var queue = DispatchQueue(label: "file_shared_manager", attributes: [])
    
    fileprivate func createPath(_ path:String)
    {
        if (!FileManager.default.fileExists(atPath: path))
        {
            let _ = try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func getDirByUrl(_ url:URL)->String?
    {
        var fileName = url.absoluteString.components(separatedBy: "/").last
        if fileName == nil
        {
            return nil
        }
        fileName = fileName!.removingPercentEncoding
        if fileName!.contains(".txt") || fileName!.contains(".TXT") {
            return FileSharedManager.PATH_SHARED_TXT
        }else if fileName!.contains(".doc") || fileName!.contains(".DOC")
        {
            return FileSharedManager.PATH_SHARED_DOC
        }else if fileName!.contains(".ppt") || fileName!.contains(".PPT")
        {
            return FileSharedManager.PATH_SHARED_PPT
        }else if fileName!.contains(".xls") || fileName!.contains(".XLS")
        {
            return FileSharedManager.PATH_SHARED_XLS
        }else if fileName!.contains(".pdf") || fileName!.contains(".PDF")
        {
            return FileSharedManager.PATH_SHARED_PDF
        }else if fileName!.contains(".apk") || fileName!.contains(".APK")
        {
            return FileSharedManager.PATH_SHARED_APK
        }else{
            return FileSharedManager.PATH_SHARED_OTHER
        }
    }
    
    func wirteToFile(_ url:URL, callback:((_ b:Bool, _ msg:String?)->Void)?)
    {
        queue.async {
            let dir = self.getDirByUrl(url)
            var fileName = url.absoluteString.components(separatedBy: "/").last
            if fileName == nil || dir == nil
            {
                return
            }
            fileName = fileName!.removingPercentEncoding
            self.createPath(dir!)
            let path = dir! + fileName!
            do{
                let data = try? Data(contentsOf: url)
                try data?.write(to: URL(fileURLWithPath: path), options: NSData.WritingOptions.atomicWrite)
                DispatchQueue.main.async(execute: {
                    if callback != nil
                    {
                        callback!(true, "")
                    }
                })
            }catch{
                if callback != nil
                {
                    callback!(false, "write to file failure")
                }
            }
        }
    }
    
    func getFileAtPath(_ path:String)->[DocumentFile]
    {
        var files = [DocumentFile]()
        do{
            let array = try FileManager.default.contentsOfDirectory(atPath: path)
            for name in array
            {
                let info = try? FileManager.default.attributesOfItem(atPath: path + name)
                var size = 0
                if info != nil
                {
                    size = info![FileAttributeKey.size] as! Int
                    //                    size = info!["NSFileSize"] as! Int
                    
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
