//
//  ProjectWorkDetailViewController_New.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import WebKit

class ProjectWorkDetailViewController_New: BasePortraitViewController {
    
    var hiddenItem = false
    var id:String = ""
    
    var scrollView:UIScrollView!
    var topView:UIView!
    
    var titleLabel:UILabel!
    var sourceLabel:UILabel!
    var timeLabel:UILabel!
    
    var progressBgView:UIView!
    var progressView:UIView!
    var progressLabel:UILabel!
    
    var projectBasicView:ProjectBasicView!
    var projectTimeView:ProjectTimeView!
    var projectNextView:ProjectNextView!
    
    var basicBtn:UIButton!
    var requireBtn:UIButton!
    var progressBtn:UIButton!
    var problemBtn:UIButton!
    var btnArray = [UIButton]()
    var contentView:UIView!
    
    var dataSource:ProjectWorkDetail?
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "重点项目"
        
        scrollView = UIScrollView(frame: self.view.bounds)
        self.view.addSubview(scrollView)
        
        topView = UIView(frame: CGRect(x: 5, y: 0, width: GetSWidth()-10, height: 60))
        scrollView.addSubview(topView)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: topView.frame.width, height: 40))
//        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.textAlignment = .center
        topView.addSubview(titleLabel)
        
        progressBgView = UIView(frame: CGRect(x: 0, y: 40, width: topView.frame.width, height: 15))
        progressBgView.backgroundColor = ThemeManager.current().backgroundColor
        progressBgView.layer.cornerRadius = 10
        progressBgView.layer.masksToBounds = true
        topView.addSubview(progressBgView)
        
        progressView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: progressBgView.frame.height))
        progressView.backgroundColor = UIColor.green
        progressBgView.addSubview(progressView)
        
        progressLabel = UILabel(frame: progressBgView.bounds)
        progressLabel.textColor = ThemeManager.current().grayFontColor
        progressLabel.text = "已完成:"
        progressLabel.font = UIFont.systemFont(ofSize: 13)
        progressBgView.addSubview(progressLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: topView.frame.height-1, width: GetSWidth(), height: 1))
        line.backgroundColor = ThemeManager.current().backgroundColor
        topView.addSubview(line)
        
        let script = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=\(GetSWidth()*2)px'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wks = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let ctrl = WKUserContentController()
        ctrl.addUserScript(wks)
        
        let config = WKWebViewConfiguration()
        config.userContentController = ctrl
        
        let btnView = UIView(frame: CGRect(x: 0, y: 60, width: GetSWidth(), height: 45))
        btnView.backgroundColor = ThemeManager.current().backgroundColor
        scrollView.addSubview(btnView)
        let width = (GetSWidth()-40)/3
        basicBtn = UIButton(frame: CGRect(x: 10, y: 7, width: width, height: 31))
        basicBtn.setTitle("基本情况", for: UIControlState())
        basicBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        basicBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        basicBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController_New.btnClicked(_:)), for: .touchUpInside)
        btnArray.append(basicBtn)
        btnView.addSubview(basicBtn)
        
        progressBtn = UIButton(frame: CGRect(x: width+20, y: 7, width: width, height: 31))
        progressBtn.setTitle("推进情况", for: UIControlState())
        progressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        progressBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        btnView.addSubview(progressBtn)
        btnArray.append(progressBtn)
        progressBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController_New.btnClicked(_:)), for: .touchUpInside)
        
//        problemBtn = UIButton(frame: CGRect(x: width*2+30, y: 7, width: width, height: 31))
//        problemBtn.setTitle("存在问题", forState: .Normal)
//        problemBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
//        problemBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: .Normal)
//        btnView.addSubview(problemBtn)
//        btnArray.append(problemBtn)
//        problemBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController_New.btnClicked(_:)), forControlEvents: .TouchUpInside)
        
        requireBtn = UIButton(frame: CGRect(x: width*2+30, y: 7, width: width, height: 31))
        requireBtn.setTitle("下步打算", for: UIControlState())
        requireBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        requireBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        btnView.addSubview(requireBtn)
        btnArray.append(requireBtn)
        requireBtn.addTarget(self, action: #selector(ProjectWorkDetailViewController_New.btnClicked(_:)), for: .touchUpInside)
        
        contentView = UIView(frame: CGRect(x: 0, y: 105, width: GetSWidth(), height: GetSHeight()-105-64))
        scrollView.addSubview(contentView)
        
        projectBasicView = ProjectBasicView(frame: contentView.bounds)
        contentView.addSubview(projectBasicView)
        
        projectTimeView = ProjectTimeView(frame: contentView.bounds)
        contentView.addSubview(projectTimeView)
        
        projectNextView = ProjectNextView(frame: contentView.bounds)
        contentView.addSubview(projectNextView)
        
        contentView.bringSubview(toFront: projectBasicView)
        
        sourceLabel = UILabel(frame: CGRect(x: 10, y: -100, width: scrollView.frame.width/2-10, height: 20))
        sourceLabel.text = "来源:"
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = ThemeManager.current().darkGrayFontColor
        scrollView.addSubview(sourceLabel)
        
        timeLabel = UILabel(frame: CGRect(x: scrollView.frame.width/2, y: -100, width: scrollView.frame.width/2-10, height: 20))
        timeLabel.text = ""
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textAlignment = .right
        timeLabel.textColor = ThemeManager.current().darkGrayFontColor
        scrollView.addSubview(timeLabel)
        
        self.loadData()
        
        for btn in btnArray
        {
            btn.layer.cornerRadius = btn.frame.height/2;
            btn.layer.masksToBounds = true
            btn.backgroundColor = ThemeManager.current().foregroundColor
            btn.setTitleColor(ThemeManager.current().grayFontColor, for: UIControlState())
        }
        
        self.btnClicked(basicBtn)
        
        if UserInfo.sharedInstance.adviceEnabled() && !hiddenItem{
            let assignItem = UIBarButtonItem(title: "批示", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProjectWorkDetailViewController_New.assignBtnClicked))
            self.navigationItem.rightBarButtonItem = assignItem
        }
        
        // Do any additional setup after loading the view.
    }
    
    func assignBtnClicked()
    {
        if dataSource?.id == nil {
            return
        }
        
        let list = PublishApproveViewController()
        list.id = dataSource?.id
        list.type = "1"
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    func btnClicked(_ btn:UIButton)
    {
        for b in btnArray {
            if btn.isEqual(b)
            {
                b.backgroundColor = ThemeManager.current().mainColor
                b.setTitleColor(ThemeManager.current().whiteFontColor, for: UIControlState())
            }else{
                b.backgroundColor = ThemeManager.current().foregroundColor
                b.setTitleColor(ThemeManager.current().grayFontColor, for: UIControlState())
            }
        }
        if dataSource == nil {
            return
        }
        
        let index = btnArray.index(of: btn)
        if index == 0 {
            contentView.bringSubview(toFront: projectBasicView)
        }else if index == 1
        {
            contentView.bringSubview(toFront: projectTimeView)
        }else if index == 2
        {
            contentView.bringSubview(toFront: projectNextView)
        }else if index == 3
        {
            
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
    
    func update(_ data:ProjectWorkDetail?)
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
        
        if dataSource?.progress != nil {
            let num = Float(dataSource!.progress!)
            progressLabel.text = "已完成：\(num!)%"
            UIView.animate(withDuration: 1, animations: {
                self.progressView.frame = CGRect(x: 0, y: 0, width: self.progressBgView.frame.width*CGFloat(num!/100), height: self.progressView.frame.height)
            })
            
        }
        
        timeLabel.text = dataSource!.publish_date
        
        projectBasicView.update(self.dataSource)
        projectTimeView.update(self.dataSource)
        projectNextView.update(self.dataSource)
        
        self.btnClicked(basicBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
