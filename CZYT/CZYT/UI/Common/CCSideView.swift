//
//  CCSideView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class CCSideView: UIView {

    static let LeftWidth = GetSWidth() * 0.7
    var isShow = false
    var leftView:UIView!
    var contentView:UIView!
    var blackView:UIView!
    
    var openBtn:UIButton!
    
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
        self.clipsToBounds = true
        
        self.addSubview(leftView!)
        self.addSubview(contentView!)
        contentView.layer.shadowOffset = CGSize(width: -4, height: -2)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        
        blackView = UIView(frame: contentView.bounds)
        blackView.backgroundColor = UIColor.black
        blackView.alpha = 0
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CCSideView.pan(_:)))
        self.addGestureRecognizer(panGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CCSideView.hide))
        
        let openView = UIView(frame: CGRect(x: 0, y: contentView.frame.height/2-32.5, width: 45, height: 65))
        openView.clipsToBounds = true
        contentView.addSubview(openView)
        
        openBtn = UIButton(frame: CGRect(x: -12, y: 0, width: openView.frame.width, height: openView.frame.height))
        openBtn.setBackgroundImage(UIImage(named: "side_open"), for: UIControlState())
        openView.addSubview(openBtn)
        openBtn.addTarget(self, action: #selector(CCSideView.openBtnClicked), for: .touchUpInside)
    }
    
    func openBtnClicked()
    {
        if self.isShow
        {
            self.hide()
        }else{
            self.show()
        }
    }
    
    func pan(_ pan:UIPanGestureRecognizer)
    {
        if pan.state == .began
        {
            contentView.addSubview(blackView)
        }
        else if pan.state == .changed
        {
            var x:CGFloat = 0
            x = pan.translation(in: self).x
            print(x)
            
            if x > 0 && !self.isShow
            {
                UIView.animate(withDuration: 0.1, animations: {
                    var frame = self.leftView.frame
                    frame.origin.x = x/CCSideView.LeftWidth * self.leftView.frame.width/2 - self.leftView.frame.width/2
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
                    
                    self.blackView.alpha = 0.2 * frame.origin.x/CCSideView.LeftWidth
                })
            }
            
        }else if pan.state == .ended
        {
            if self.contentView.frame.origin.x > CCSideView.LeftWidth/3
            {
                self.show()
            }else{
                self.hide()
            }
        }
        
    }
    
    func show()
    {
        contentView.addSubview(blackView)
        contentView.addGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.2, animations: {
            var frame = self.leftView.frame
            frame.origin.x = 0
            self.leftView.frame = frame
            
            frame = self.contentView.frame
            frame.origin.x = CCSideView.LeftWidth
            self.contentView.frame = frame
            
            self.blackView.alpha = 0.2
            }, completion: { (b) in
                self.isShow = true
                self.openBtn.setBackgroundImage(UIImage(named: "side_close"), for: UIControlState())
        }) 
    }
    
    func hide()
    {
        contentView.removeGestureRecognizer(tapGesture)
        UIView.animate(withDuration: 0.2, animations: {
            var frame = self.leftView.frame
            frame.origin.x = -self.leftView.frame.width/2
            self.leftView.frame = frame
            
            frame = self.contentView.frame
            frame.origin.x = 0
            self.contentView.frame = frame
            
            self.blackView.alpha = 0
        }, completion: { (b) in
            self.isShow = false
            self.blackView.removeFromSuperview()
            self.openBtn.setBackgroundImage(UIImage(named: "side_open"), for: UIControlState())
        }) 
    }
}
