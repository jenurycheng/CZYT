//
//  BaseDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import WebKit

class BaseDetailViewController: BasePortraitViewController {

    var scrollView:UIScrollView!
    var topView:UIView!
    
    var titleLabel:UILabel!
    var sourceLabel:UILabel!
    var timeLabel:UILabel!
    
    var webView:WKWebView!
    
    var zoomOutBtn:UIButton!
    var zoomInBtn:UIButton!
    
    var dataSource:LeaderActivityDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "详情"
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        topView = UIView(frame: CGRect(x: 5, y: 0, width: GetSWidth()-10, height: 70))
        scrollView.addSubview(topView)
        
        titleLabel = UILabel(frame: CGRect(x: 10, y: 0, width: topView.frame.width-20, height: 40))
//        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.adjustsFontSizeToFitWidth = true
        topView.addSubview(titleLabel)
        
        sourceLabel = UILabel(frame: CGRect(x: 0, y: 40, width: topView.frame.width/2, height: 30))
        sourceLabel.text = "来源:"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(sourceLabel)
        
        timeLabel = UILabel(frame: CGRect(x: topView.frame.width/2, y: 40, width: topView.frame.width/2, height: 30))
        timeLabel.textAlignment = .right
        timeLabel.text = ""
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = ThemeManager.current().darkGrayFontColor
        topView.addSubview(timeLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: topView.frame.height-1, width: GetSWidth(), height: 1))
        line.backgroundColor = ThemeManager.current().backgroundColor
        topView.addSubview(line)
        
        let script = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=\(GetSWidth()*2)px'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wks = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let ctrl = WKUserContentController()
        ctrl.addUserScript(wks)
        
        let config = WKWebViewConfiguration()
//        config.userContentController = ctrl
        
        webView = WKWebView(frame: CGRect(x: 5, y: 70, width: GetSWidth()-10, height: GetSHeight()-70-64), configuration: config)
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        scrollView.addSubview(webView)
        
        zoomOutBtn = UIButton(frame: CGRect(x: 0, y: GetSHeight()-100-64, width: 40, height: 40))
        zoomOutBtn.backgroundColor = ThemeManager.current().backgroundColor
        zoomOutBtn.setTitle("+", for: UIControlState())
        zoomOutBtn.addTarget(self, action: #selector(BaseDetailViewController.zoomOutBtnClicked), for: .touchUpInside)
//        self.view.addSubview(zoomOutBtn)
        
        zoomInBtn = UIButton(frame: CGRect(x: 0, y: zoomOutBtn.frame.origin.y + zoomOutBtn.frame.height, width: 40, height: 40))
        zoomInBtn.setTitle("-", for: UIControlState())
        zoomInBtn.backgroundColor = ThemeManager.current().backgroundColor
//        self.view.addSubview(zoomInBtn)
        // Do any additional setup after loading the view.
    }
    
    var scale:CGFloat = 1
    func zoomOutBtnClicked()
    {
        scale = scale * 1.1
        let trans = CGAffineTransform(scaleX: scale, y: scale)
        webView.transform = trans
        
        let size = scrollView.contentSize
        scrollView.contentSize = CGSize(width: size.width * 1.1, height: size.height * 1.1)
    }
    
    func zoomInBtnClicked()
    {
        
    }
    
    func update(_ data:LeaderActivityDetail?)
    {
        if data == nil
        {
            return
        }
        self.dataSource = data
        titleLabel.text = dataSource!.title
        
        let attribute = NSMutableAttributedString(string: "")
        attribute.appendAttributeString("来源:", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFont(ofSize: 12))
        let source = dataSource!.original ?? ""
        attribute.appendAttributeString(source, color: UIColor.orange, font: UIFont.systemFont(ofSize: 12))
        sourceLabel.attributedText = attribute
        timeLabel.text = dataSource!.publish_date
        let data = dataSource?.content//.replacingOccurrencesOfString("width: 1000px", withString: "width: \(GetSWidth()*2)px")
        webView.loadHTMLString(data!, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseDetailViewController : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchAfter(0.2, queue: DispatchQueue.main) { 
            self.webView.frame = CGRect(x: 5, y: 70, width: GetSWidth()-10, height: self.webView.scrollView.contentSize.height)
            let height = self.webView.frame.height + 100 > GetSHeight() ? self.webView.frame.height + 100 : GetSHeight()
            self.scrollView.contentSize = CGSize(width: GetSWidth(), height: height)
            
            print(self.webView.contentScaleFactor)
        }
    }
}
