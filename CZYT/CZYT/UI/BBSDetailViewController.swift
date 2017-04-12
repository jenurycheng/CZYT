//
//  BBSDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBSDetailViewController: BasePortraitViewController {

    var id:String = ""
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var commentCountBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!
    
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    
    var dataSource = BBSDataSource()
    
    @IBAction func commentCountBtnClicked()
    {
        let c = BBSCommentViewController()
        c.id = self.id
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func commentBtnClicked()
    {
        let c = BBSCommentViewController()
        c.isComment = true
        c.id = self.id
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.timeLabel.adjustsFontSizeToFitWidth = true
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight()-64
        commentBtn.layer.cornerRadius = commentBtn.frame.height/2
        commentBtn.layer.masksToBounds = true

        webView.delegate = self
        webView.scalesPageToFit = true
        webView.scrollView.isScrollEnabled = false
//        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSource.getBBSDetail(id, success: { (result) in
            self.updateView()
            self.view.dismiss()
            }) { (error) in
                self.view.dismiss()
                NetworkErrorView.show(self.view, data: error, callback: { 
                    self.loadData()
                })
        }
    }
    
    func updateView()
    {
        titleLabel.text = dataSource.bbsDetail?.title
        timeLabel.text = dataSource.bbsDetail?.publish_date
        commentCountBtn.setTitle("\(dataSource.bbsDetail!.comment_count!)条评论", for: UIControlState())
        if dataSource.bbsDetail?.summary != nil {
            let data = "<p style=\"font-size:40px;\">\(dataSource.bbsDetail!.summary!)</p>"
            
            webView.loadHTMLString(data, baseURL: nil)
        }
        
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

extension BBSDetailViewController : UIWebViewDelegate
{
    func webViewDidFinishLoad(_ webView: UIWebView) {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
        return true
    }
}
