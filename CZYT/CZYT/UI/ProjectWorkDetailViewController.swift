//
//  ProjectWorkDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import WebKit

class ProjectWorkDetailViewController: BasePortraitViewController {
    
    var id:String = ""
    
    var scrollView:UIScrollView!
    var topView:UIView!
    
    var titleLabel:UILabel!
    var sourceLabel:UILabel!
    var timeLabel:UILabel!
    
    var typeLabel:UILabel!
    var countLabel:UILabel!
    
    var webView:WKWebView!
    
    var dataSource:LeaderActivityDetail?
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "详情"
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        topView = UIView(frame: CGRect(x: 5, y: 0, width: GetSWidth()-10, height: 90))
        scrollView.addSubview(topView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: topView.frame.width, height: 40))
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .ByCharWrapping
        titleLabel.textAlignment = .Center
        topView.addSubview(titleLabel)
        
        typeLabel = UILabel(frame: CGRect(x: 0, y: 40, width: topView.frame.width/2, height: 30))
        typeLabel.text = "类型:"
        typeLabel.font = UIFont.systemFontOfSize(12)
        typeLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(typeLabel)
        
        countLabel = UILabel(frame: CGRect(x: topView.frame.width/2, y: 40, width: topView.frame.width/2, height: 30))
        countLabel.text = ""
        countLabel.textAlignment = .Right
        countLabel.font = UIFont.systemFontOfSize(12)
        countLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(countLabel)
        
        sourceLabel = UILabel(frame: CGRect(x: 0, y: 70, width: topView.frame.width/2, height: 20))
        sourceLabel.text = "来源:"
        sourceLabel.font = UIFont.systemFontOfSize(12)
        sourceLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(sourceLabel)
        
        timeLabel = UILabel(frame: CGRect(x: topView.frame.width/2, y: 70, width: topView.frame.width/2, height: 20))
        timeLabel.text = ""
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textAlignment = .Right
        timeLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(timeLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: topView.frame.height-1, width: GetSWidth(), height: 1))
        line.backgroundColor = ThemeManager.current().backgroundColor
        topView.addSubview(line)
        
        let script = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=\(GetSWidth()*2)px'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wks = WKUserScript(source: script, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        let ctrl = WKUserContentController()
        ctrl.addUserScript(wks)
        
        let config = WKWebViewConfiguration()
        config.userContentController = ctrl
        
        webView = WKWebView(frame: CGRect(x: 5, y: 90, width: GetSWidth()-10, height: GetSHeight()-90-64), configuration: config)
        webView.navigationDelegate = self
        webView.scrollView.scrollEnabled = false
        scrollView.addSubview(webView)
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSourceApi.getProjectWorkActivityDetail(id, success: { (result) in
            self.update(result)
            self.view.dismiss()
        }) { (error) in
            self.view.dismiss()
            NetworkErrorView.show(self.view, data: error, callback: {
                
            })
        }
    }
    
    func update(data:LeaderActivityDetail?)
    {
        if data == nil
        {
            return
        }
        self.dataSource = data
        titleLabel.text = dataSource!.title
        
        let tattribute = NSMutableAttributedString(string: "")
        tattribute.appendAttributeString("类型:", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
        let type = dataSource!.type ?? ""
        tattribute.appendAttributeString(type, color: UIColor.orangeColor(), font: UIFont.systemFontOfSize(12))
        typeLabel.attributedText = tattribute
        
        var account = "0"
        if !Helper.isStringEmpty(dataSource!.amount) {
            account = dataSource!.amount!
        }
        let cattribute = NSMutableAttributedString()
        cattribute.appendAttributeString("项目金额：", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
        cattribute.appendAttributeString("\(account)元", color: UIColor.redColor(), font: UIFont.systemFontOfSize(15))
        
        countLabel.attributedText = cattribute
        
        let source = dataSource!.original ?? ""
        sourceLabel.text = "来源:" + source
        
        timeLabel.text = dataSource!.publish_date
        webView.loadHTMLString(dataSource!.content, baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ProjectWorkDetailViewController : WKNavigationDelegate
{
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        DispatchAfter(0.2, queue: dispatch_get_main_queue()) {
            self.webView.frame = CGRect(x: 5, y: 90, width: GetSWidth()-10, height: self.webView.scrollView.contentSize.height)
            let height = self.webView.frame.height + 90 > GetSHeight() ? self.webView.frame.height + 90 : GetSHeight()
            self.scrollView.contentSize = CGSize(width: GetSWidth(), height: height)
            
            print(self.webView.contentScaleFactor)
        }
    }
}
