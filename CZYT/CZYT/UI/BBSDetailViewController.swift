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
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var typeLabel:UILabel!
    @IBOutlet weak var webView:UIWebView!
    @IBOutlet weak var commentCountBtn:UIButton!
    @IBOutlet weak var commentBtn:UIButton!
    
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    
    var dataSource = BBSDataSource()
    
    @IBAction func commentCountBtnClicked()
    {
        let c = BBSCommentViewController()
        self.navigationController?.pushViewController(c, animated: true)
    }
    
    @IBAction func commentBtnClicked()
    {
        let c = BBSCommentViewController()
        c.isComment = true
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
        webView.scrollView.scrollEnabled = false
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
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
        sourceLabel.text = dataSource.bbsDetail?.original
        timeLabel.text = dataSource.bbsDetail?.publish_date
        typeLabel.text = dataSource.bbsDetail?.classify
        commentCountBtn.setTitle("\(dataSource.bbsDetail!.comment_count)条评论", forState: .Normal)
        if dataSource.bbsDetail?.content != nil {
            webView.loadHTMLString(dataSource.bbsDetail!.content!, baseURL: nil)
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
    func webViewDidFinishLoad(webView: UIWebView) {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
        return true
    }
}
