//
//  NetworkErrorView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class NetworkErrorView: UIView {
    
    var callback:(()->Void)?
    
    var retryBtn:UIButton!
    
    var isAutoRemove:Bool! = true
    
    var imageView:UIImageView!
    var hintLabel:UILabel!
    var hintDetailLabel:UILabel!
    
    init(frame: CGRect, callback:@escaping (()->Void), isAutoRemove:Bool = true) {
        super.init(frame: frame)
        self.callback = callback
        self.isAutoRemove = isAutoRemove
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        self.backgroundColor = ThemeManager.current().backgroundColor
        
        let centerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: Helper.scale(700)))
        centerView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.addSubview(centerView)
        
        imageView = UIImageView(frame: CGRect(x: centerView.frame.size.width/2-Helper.scale(200), y: 0, width: Helper.scale(400), height: Helper.scale(400)))
        imageView.image = UIImage(named: "wifi_error")
        centerView.addSubview(imageView)
        
        hintLabel = UILabel(frame: CGRect(x: 0, y: Helper.scale(400), width: centerView.frame.size.width, height: 20))
        hintLabel.textAlignment = NSTextAlignment.center
        hintLabel.text = "网络未连接"
        hintLabel.textColor = ThemeManager.current().darkGrayFontColor
        hintLabel.font = UIFont.systemFont(ofSize: 18)
        centerView.addSubview(hintLabel)
        
        hintDetailLabel = UILabel(frame: CGRect(x: 0, y: Helper.scale(400) + 20, width: centerView.frame.size.width, height: 50))
        hintDetailLabel.textAlignment = NSTextAlignment.center
        hintDetailLabel.textColor = ThemeManager.current().grayFontColor
        hintDetailLabel.text = "请检查网络连接, 再点击屏幕刷新"
        hintDetailLabel.numberOfLines = 2
        hintDetailLabel.font = UIFont.systemFont(ofSize: 13)
        centerView.addSubview(hintDetailLabel)
        
        retryBtn = UIButton(frame: self.bounds)
        self.addSubview(retryBtn)
        retryBtn.addTarget(self, action: #selector(NetworkErrorView.retryBtnClicked), for: UIControlEvents.touchUpInside)
    }
    
    func update(_ data:HttpResponseData)
    {
        if data.code == HttpResponseData.CODE_SERVER_ERROR {
            imageView.image = UIImage(named: "data_error")
            hintLabel.text = "出错了"
            hintDetailLabel.text = "服务器崩溃了，再点击屏幕重试"
        }
    }
    
    class func show(_ parentView:UIView, data:HttpResponseData, callback:@escaping (()->Void))
    {
        let tag = 0x562
        var view = parentView.viewWithTag(tag) as? NetworkErrorView
        if view == nil {
            view = NetworkErrorView(frame: parentView.bounds, callback: callback)
            view?.tag = tag
            view?.update(data)
        }
        view?.callback = callback
        parentView.addSubview(view!)
    }
    
    func retryBtnClicked()
    {
        if true == self.isAutoRemove {
            self.removeFromSuperview()
        }
        
        if callback != nil
        {
            callback!()
        }
    }

}
