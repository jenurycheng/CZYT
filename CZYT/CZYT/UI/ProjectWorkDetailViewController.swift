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
    
    var hiddenItem = false
    var id:String = ""
    
    var scrollView:UIScrollView!
    var topView:UIView!
    
    var titleLabel:UILabel!
    var sourceLabel:UILabel!
    var timeLabel:UILabel!
    
//    var progressBgView:UIView!
//    var progressView:UIView!
//    var progressLabel:UILabel!
    
    var basicBtn:UIButton!
    var requireBtn:UIButton!
    var progressBtn:UIButton!
    var problemBtn:UIButton!
    var btnArray = [UIButton]()
    var webView:WKWebView!
    
    var dataSource:LeaderActivityDetail?
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "重点项目"
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        topView = UIView(frame: CGRect(x: 5, y: 0, width: GetSWidth()-10, height: 40))
        scrollView.addSubview(topView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: topView.frame.width, height: 40))
//        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .ByCharWrapping
        titleLabel.textAlignment = .Center
        topView.addSubview(titleLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: topView.frame.height-1, width: GetSWidth(), height: 1))
        line.backgroundColor = ThemeManager.current().backgroundColor
        topView.addSubview(line)
        
        let script = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=\(GetSWidth()*2)px'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wks = WKUserScript(source: script, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        let ctrl = WKUserContentController()
        ctrl.addUserScript(wks)
        
        let config = WKWebViewConfiguration()
        config.userContentController = ctrl
        
        let btnView = UIView(frame: CGRect(x: 0, y: 40, width: GetSWidth(), height: 45))
        btnView.backgroundColor = ThemeManager.current().backgroundColor
        scrollView.addSubview(btnView)
        let width = (GetSWidth()-50)/4
        basicBtn = UIButton(frame: CGRect(x: 10, y: 7, width: width, height: 31))
        basicBtn.setTitle("基本情况", forState: .Normal)
        basicBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        basicBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: .Normal)
        basicBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController.btnClicked(_:)), forControlEvents: .TouchUpInside)
        btnArray.append(basicBtn)
        btnView.addSubview(basicBtn)
        
        progressBtn = UIButton(frame: CGRect(x: width+20, y: 7, width: width, height: 31))
        progressBtn.setTitle("推进情况", forState: .Normal)
        progressBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        progressBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: .Normal)
        btnView.addSubview(progressBtn)
        btnArray.append(progressBtn)
        progressBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController.btnClicked(_:)), forControlEvents: .TouchUpInside)
        
        problemBtn = UIButton(frame: CGRect(x: width*2+30, y: 7, width: width, height: 31))
        problemBtn.setTitle("存在问题", forState: .Normal)
        problemBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        problemBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: .Normal)
        btnView.addSubview(problemBtn)
        btnArray.append(problemBtn)
        problemBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController.btnClicked(_:)), forControlEvents: .TouchUpInside)
        
        requireBtn = UIButton(frame: CGRect(x: width*3+40, y: 7, width: width, height: 31))
        requireBtn.setTitle("工作要求", forState: .Normal)
        requireBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        requireBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: .Normal)
        btnView.addSubview(requireBtn)
        btnArray.append(requireBtn)
        requireBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController.btnClicked(_:)), forControlEvents: .TouchUpInside)
        
        webView = WKWebView(frame: CGRect(x: 5, y: 85, width: GetSWidth()-10, height: 10), configuration: config)
        webView.navigationDelegate = self
        webView.scrollView.scrollEnabled = false
        scrollView.addSubview(webView)
        
        sourceLabel = UILabel(frame: CGRect(x: 10, y: -100, width: scrollView.frame.width/2-10, height: 20))
        sourceLabel.text = "来源:"
        sourceLabel.font = UIFont.systemFontOfSize(12)
        sourceLabel.textColor = ThemeManager.current().darkGrayFontColor
        scrollView.addSubview(sourceLabel)
        
        timeLabel = UILabel(frame: CGRect(x: scrollView.frame.width/2, y: -100, width: scrollView.frame.width/2-10, height: 20))
        timeLabel.text = ""
        timeLabel.font = UIFont.systemFontOfSize(12)
        timeLabel.textAlignment = .Right
        timeLabel.textColor = ThemeManager.current().darkGrayFontColor
        scrollView.addSubview(timeLabel)
        
        self.loadData()
        
        for btn in btnArray
        {
            btn.layer.cornerRadius = btn.frame.height/2;
            btn.layer.masksToBounds = true
            btn.backgroundColor = ThemeManager.current().foregroundColor
            btn.setTitleColor(ThemeManager.current().grayFontColor, forState: .Normal)
        }
        
        self.btnClicked(basicBtn)
        
        if !hiddenItem {
            let assignItem = UIBarButtonItem(title: "指派", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ProjectWorkDetailViewController.assignBtnClicked))
            self.navigationItem.rightBarButtonItem = assignItem
        }
        
        // Do any additional setup after loading the view.
    }
    
    func assignBtnClicked()
    {
        if dataSource?.id == nil {
            return
        }
        let publish = PublishTaskViewController(nibName: "PublishTaskViewController", bundle: nil)
        publish.taskID = dataSource?.id
        self.navigationController?.pushViewController(publish, animated: true)
    }
    
    func btnClicked(btn:UIButton)
    {
        for b in btnArray {
            if btn.isEqual(b)
            {
                b.backgroundColor = ThemeManager.current().mainColor
                b.setTitleColor(ThemeManager.current().whiteFontColor, forState: .Normal)
            }else{
                b.backgroundColor = ThemeManager.current().foregroundColor
                b.setTitleColor(ThemeManager.current().grayFontColor, forState: .Normal)
            }
        }
        if dataSource == nil {
            return
        }
        
        webView.frame = CGRect(x: 5, y: 85, width: GetSWidth()-10, height: 10)
        let index = btnArray.indexOf(btn)
        sourceLabel.hidden = true
        timeLabel.hidden = true
        if index == 0 {
            if dataSource?.basic != nil
            {
                webView.loadHTMLString(dataSource!.basic!, baseURL: nil)
                sourceLabel.hidden = false
                timeLabel.hidden = false
            }
        }else if index == 1
        {
            if dataSource?.promotion != nil
            {
                webView.loadHTMLString(dataSource!.promotion!, baseURL: nil)
            }
        }else if index == 2
        {
            if dataSource?.problem != nil
            {
                webView.loadHTMLString(dataSource!.problem!, baseURL: nil)
            }
        }else if index == 3
        {
            if dataSource?.requirement != nil {
                webView.loadHTMLString(dataSource!.requirement!, baseURL: nil)
            }
            
        }
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
        if data?.classify != nil {
            self.title = "重点项目/" + (dataSource?.classify ?? "")
        }
        titleLabel.text = dataSource!.title
        sourceLabel.text = "来源:" + (dataSource?.classify ?? "")
//        let tattribute = NSMutableAttributedString(string: "")
//        tattribute.appendAttributeString("类型:", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
//        let type = dataSource!.type ?? ""
//        tattribute.appendAttributeString(type, color: UIColor.orangeColor(), font: UIFont.systemFontOfSize(12))
//        sourceLabel.attributedText = tattribute
        
//        if dataSource?.progress != nil {
//            let num = Float(dataSource!.progress!)
//            progressLabel.text = "已完成：\(num!)%"
//            UIView.animateWithDuration(1, animations: {
//                self.progressView.frame = CGRect(x: 0, y: 0, width: self.progressBgView.frame.width*CGFloat(num!/100), height: 14)
//            })
//            
//        }
        
        timeLabel.text = dataSource!.publish_date
        webView.loadHTMLString(dataSource!.content, baseURL: nil)
        
        self.btnClicked(basicBtn)
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
            self.webView.frame = CGRect(x: 5, y: 85, width: GetSWidth()-10, height: self.webView.scrollView.contentSize.height)
            self.sourceLabel.frame = CGRect(x: 10, y: self.webView.frame.origin.y + self.webView.frame.height + 20, width: self.scrollView.frame.width/2-10, height: 20)
            self.timeLabel.frame = CGRect(x: self.scrollView.frame.width/2, y: self.webView.frame.origin.y + self.webView.frame.height + 20, width: self.scrollView.frame.width/2-10, height: 20)
            
            
            let height = self.webView.frame.height + 85 > GetSHeight() ? self.webView.frame.height + 85 : GetSHeight() + 20
            self.scrollView.contentSize = CGSize(width: GetSWidth(), height: height)
            
            print(self.webView.contentScaleFactor)
            
            
        }
    }
}
