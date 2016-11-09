//
//  UIView+HUD.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

extension UIView
{
    //showBlackBg 是否现实黑色方框， 默认为false，无黑色方框
    func showHud(showBlackBg:Bool = false){
        
        let obgHud = self.viewWithTag(0x1001)
        if obgHud != nil
        {
            let hud = self.viewWithTag(0x1002) as? UIActivityIndicatorView
            hud?.startAnimating()
            return
        }
        
        let bgHud = UIView(frame: CGRectMake(self.frame.size.width/2-50, self.frame.size.height/2-50, 100, 100))
        if showBlackBg
        {
            bgHud.backgroundColor = UIColor(white: 0, alpha: 0.8)
        }
        bgHud.layer.cornerRadius = 10
        bgHud.layer.masksToBounds = true
        bgHud.tag = 0x1001
        self.addSubview(bgHud)
        
        let hud = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        if showBlackBg {
            hud.activityIndicatorViewStyle = .WhiteLarge
        }
        hud.tag = 0x1002
        hud.center = CGPointMake(bgHud.bounds.size.width/2, bgHud.bounds.size.height/2)
        bgHud.addSubview(hud)
        hud.startAnimating()
    }
    
    func dismiss(){
        let hud = self.viewWithTag(0x1002) as? UIActivityIndicatorView
        hud?.stopAnimating()
        
        let bgHud = self.viewWithTag(0x1001)
        bgHud?.removeFromSuperview()
    }
    
    func showLoading()
    {
        let obg = self.viewWithTag(0x1011)
        if obg != nil {
            let animateView = obg?.viewWithTag(0x1012) as! KidAnimateView
            animateView.startAnimate()
            return
        }
        
        let bg = UIView(frame: self.bounds)
        bg.tag = 0x1011
        bg.backgroundColor = UIColor.whiteColor()
        bg.addSubview(KidAnimateView.sharedInstance)
        KidAnimateView.sharedInstance.center = CGPointMake(bg.frame.size.width/2, bg.frame.size.height/2)
        KidAnimateView.sharedInstance.tag = 0x1012
        KidAnimateView.sharedInstance.startAnimate()
        self.addSubview(bg)
    }
    
    func dismissLoading()
    {
        let bg = self.viewWithTag(0x1011)
        if bg != nil {
            let animateView = bg?.viewWithTag(0x1012) as? KidAnimateView
            animateView?.stopAnimate()
            bg?.removeFromSuperview()
        }
    }
}

class KidAnimateView : UIView
{
    class var sharedInstance : KidAnimateView
        {
        struct Sington
        {
            static let single = KidAnimateView(frame:CGRectMake(0, 0, 100, 150))
        }
        return Sington.single
    }
    
    var imageView:UIImageView!
    var textLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textLabel = UILabel(frame: CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20))
        textLabel.text = "加载中..."
        textLabel.textAlignment = NSTextAlignment.Center
        textLabel.textColor = UIColor.grayColor()
        textLabel.font = UIFont.systemFontOfSize(15)
        self.addSubview(textLabel)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        var array = Array<UIImage>()
        for i in 1...7
        {
            let image = UIImage(named: "animate_" + "\(i)")
            array.append(image!)
        }
        imageView.animationImages = array
        self.addSubview(imageView)
    }
    
    func startAnimate()
    {
        imageView.startAnimating()
    }
    
    func stopAnimate()
    {
        imageView.stopAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


