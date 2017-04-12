//
//  ProjectNextView.swift
//  CZYT
//
//  Created by jerry cheng on 2017/3/28.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit
import WebKit

class ProjectNextView: UIView {

    var webView:WKWebView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ data:ProjectWorkDetail?)
    {
        if data?.requirement != nil {
            webView.loadHTMLString(data!.requirement!, baseURL: nil)
        }
        
    }
    
    func initView()
    {
        self.backgroundColor = ThemeManager.current().foregroundColor
        
        webView = WKWebView(frame: self.bounds)
        webView.scrollView.isScrollEnabled = false
        self.addSubview(webView)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
