//
//  LeaderActivityDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivityDetailViewController: BasePortraitViewController {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var webView:UIWebView!
    
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight()-64
        
        webView.loadHTMLString("<p>\r\n\t123123</p>\r\n", baseURL: nil)
        webView.delegate = self
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

extension LeaderActivityDetailViewController : UIWebViewDelegate
{
    func webViewDidFinishLoad(webView: UIWebView) {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
    }
}
