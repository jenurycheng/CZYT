//
//  CCSideView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class CCSideView: UIView {

    var leftWidth = GetSWidth() * 0.7
    var isShow = false
    var leftView:UIView!
    var contentView:UIView!
    var blackView:UIView!
    
    var panGesture:UIPanGestureRecognizer!
    var tapGesture:UITapGestureRecognizer!
    
    init(frame: CGRect, leftView:UIView, contentView:UIView) {
        super.init(frame: frame)
        self.leftView = leftView
        self.contentView = contentView
        
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        self.addSubview(leftView!)
        self.addSubview(contentView!)
        contentView.layer.shadowOffset = CGSize(width: -4, height: -2)
        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOpacity = 0.3
        
        blackView = UIView(frame: contentView.bounds)
        blackView.backgroundColor = UIColor.blackColor()
        blackView.alpha = 0
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CCSideView.pan(_:)))
        self.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CCSideView.hide))
    }
    
    func pan(pan:UIPanGestureRecognizer)
    {
        if pan.state == .Began
        {
            contentView.addSubview(blackView)
        }
        else if pan.state == .Changed
        {
            var x:CGFloat = 0
            x = pan.translationInView(self).x
            print(x)
            
            if x > 0 && !self.isShow
            {
                UIView.animateWithDuration(0.1, animations: {
                    var frame = self.leftView.frame
                    frame.origin.x = -frame.width/2 + x/2
                    if frame.origin.x >= -frame.width/2 && frame.origin.x <= 0
                    {
                        self.leftView.frame = frame
                    }
                    
                    frame = self.contentView.frame
                    frame.origin.x = x
                    if frame.origin.x >= 0 && frame.origin.x < self.frame.width
                    {
                        self.contentView.frame = frame
                    }
                    
                    self.blackView.alpha = 0.2 * frame.origin.x/self.leftWidth
                })
            }
            
        }else if pan.state == .Ended
        {
            if self.contentView.frame.origin.x > leftWidth/3
            {
                self.show()
            }else{
                self.hide()
            }
        }
        
    }
    
    func show()
    {
        contentView.addGestureRecognizer(tapGesture)
        UIView.animateWithDuration(0.2, animations: {
            var frame = self.leftView.frame
            frame.origin.x = 0
            self.leftView.frame = frame
            
            frame = self.contentView.frame
            frame.origin.x = self.leftWidth
            self.contentView.frame = frame
            
            self.blackView.alpha = 0.2
            }) { (b) in
                self.isShow = true
        }
    }
    
    func hide()
    {
        contentView.removeGestureRecognizer(tapGesture)
        UIView.animateWithDuration(0.2, animations: {
            var frame = self.leftView.frame
            frame.origin.x = -self.leftView.frame.width/2
            self.leftView.frame = frame
            
            frame = self.contentView.frame
            frame.origin.x = 0
            self.contentView.frame = frame
            
            self.blackView.alpha = 0
        }) { (b) in
            self.isShow = false
            self.blackView.removeFromSuperview()
        }
    }
}
