//
//  WorkStatusActivityDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/8.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class WorkStatusActivityDetailViewController: BasePortraitViewController {

    var id:String = ""
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var sourceLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var webView:UIWebView!
    
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    
    var dataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详情"
        self.timeLabel.adjustsFontSizeToFitWidth = true
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight()-64

        webView.delegate = self
        webView.scalesPageToFit = true
        webView.scrollView.scrollEnabled = false
        self.loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSource.getLeaderActivityDetail(id, success: { (result) in
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
        titleLabel.text = dataSource.leaderActivityDetail?.title
        sourceLabel.text = dataSource.leaderActivityDetail?.original
        timeLabel.text = dataSource.leaderActivityDetail?.publish_date
        webView.loadHTMLString(dataSource.leaderActivityDetail!.content, baseURL: nil)
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

extension WorkStatusActivityDetailViewController : UIWebViewDelegate
{
    func webViewDidFinishLoad(webView: UIWebView) {
        contentHeight.constant = webView.scrollView.contentSize.height + 70 - 64 < GetSHeight() ? GetSHeight() : webView.scrollView.contentSize.height + 70 - 64
    }
}
