//
//  WebShowViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/18.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class WebShowViewController: BasePortraitViewController {

    var url:URL?
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "预览"
        webView = UIWebView(frame: self.view.bounds)
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        
        if url != nil
        {
            let r = URLRequest(url: url!)
            webView.loadRequest(r)
            
            if url!.absoluteString.hasPrefix("http") {
                let share = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(WebShowViewController.share))
                self.navigationItem.rightBarButtonItem = share
            }
        }
        
        // Do any additional setup after loading the view.
    }
    var task:URLSessionDownloadTask?
    func share()
    {
        let path:NSString = url!.absoluteString as NSString
        let name:String = path.lastPathComponent
        let savePath = NSTemporaryDirectory() + "/" + name
        
        if FileManager.default.fileExists(atPath: savePath)
        {
            let doc = UIDocumentInteractionController(url: URL(fileURLWithPath: savePath))
            doc.delegate = nil
            doc.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
            return;
        }
        let hub = MBProgressHUD.showMessag("正在下载", to: self.view)
        task = AFURLSessionManager().downloadTask(with: URLRequest(url: url!), progress: { (progress) in
            hub?.labelText = "正在下载\(Float(progress.completedUnitCount)/Float(progress.totalUnitCount))"
            }, destination: { (url, resp) -> URL in
                return URL(fileURLWithPath: savePath)
            }) { (resp, url, error) in
            
                if error == nil
                {
                    hub?.hide(true)
                    MBProgressHUD.showSuccess("下载完成", to: self.view)
                    
                    let doc = UIDocumentInteractionController(url: URL(fileURLWithPath: savePath))
                    doc.delegate = nil
                    doc.presentOpenInMenu(from: self.view.bounds, in: self.view, animated: true)
                }else{
                    hub?.hide(true)
                    MBProgressHUD.showError("下载失败", to: self.view)
                }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(NSEC_PER_SEC*1)) / Double(NSEC_PER_SEC)) {
            self.task?.resume()
        }
        
//        let hub = MBProgressHUD.showMessag("正在下载", toView: self.view)
//        task = AFURLSessionManager().dataTaskWithRequest(NSURLRequest(URL: url!), uploadProgress: { (progress) in
//            
//            }, downloadProgress: { (progress) in
//                print(progress)
//            hub.labelText = "正在下载\(Float(progress.completedUnitCount)/Float(progress.totalUnitCount))"
//            }) { (res, obj, error) in
//                hub.hide(true)
//                if error == nil
//                {
//                    let data:NSData? = obj as? NSData
//                    print(data?.length)
//                }
//        }
//        task?.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
