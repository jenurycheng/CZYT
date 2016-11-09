//
//  WebViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class WebViewController: BasePortraitViewController {

    var url:String?
    var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        if url == nil
        {
            url = ""
        }
        let r = NSURLRequest(URL: NSURL(string: url!)!)
        webView.loadRequest(r)
        // Do any additional setup after loading the view.
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
