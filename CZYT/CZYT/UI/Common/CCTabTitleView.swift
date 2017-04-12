//
//  CCTabTitleView.swift
//  GiMiHelper_3.0
//
//  Created by shuaidan on 16/8/9.
//  Copyright © 2016年 shuaidan. All rights reserved.
//

import UIKit

import UIKit
import Foundation

protocol CCTabTitleViewDelegate: NSObjectProtocol
{
    func titleCount()->Int!
    func titleForPosition(_ pos:NSInteger)->String!
    func titleViewIndexDidSelected(_ titleView:CCTabTitleView, index:Int)
}

class CCTabTitleView: UIView {
    weak var delegate:CCTabTitleViewDelegate?
        {
        didSet{
            self.reloadView()
        }
    }
    
    var font:UIFont?
    var textArray:Array<String?>!
    var viewArray:Array<UIView>!
    
    var leftSpacing:CGFloat!
    var rightSpacing:CGFloat!
    
    var spacingLineHidden:Bool = false
    var lineView:UIView!
    var blueLineView:UIView!
    var btnArray:Array<UIButton>!
    
    var curPos:CGFloat!
    var normalTextColor = ThemeManager.current().darkGrayFontColor
    var selectTextColor = Helper.parseColor(0x4392F3FF)
    var btnWidth:CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData(){
        textArray = Array<String!>()
        btnArray = Array<UIButton>()
        leftSpacing = 0
        rightSpacing = 0
        curPos = 0
    }
    
    func setDelegate(_ delegate:CCTabTitleViewDelegate){
        self.delegate = delegate
        self.reloadView()
    }
    
    func resetView()
    {
        for i in self.subviews
        {
            i.removeFromSuperview()
        }
        textArray.removeAll(keepingCapacity: false)
        btnArray.removeAll(keepingCapacity: false)
    }
    
    func reloadView(){
        self.resetView()
        
        if delegate == nil
        {
            return
        }
        
        let count:NSInteger! = delegate?.titleCount()
        var width:CGFloat = (self.frame.size.width-leftSpacing-rightSpacing)/CGFloat(count)
        if btnWidth != nil
        {
            width = btnWidth!
        }
        
        if count != nil
        {
            for i in 0 ..< count
            {
                let text:String? = delegate!.titleForPosition(i)
                textArray.append(text)
                let btn:UIButton! = UIButton(frame: CGRect(x: leftSpacing+width*CGFloat(i), y: 0, width: width, height: self.frame.size.height-2))
                btn.setTitle(text, for: UIControlState())
                btn.setTitleColor(selectTextColor, for: UIControlState())
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                if font != nil
                {
                    btn.titleLabel?.font = font
                }
                self.addSubview(btn)
                btnArray.append(btn)
                btn.addTarget(self, action: #selector(CCTabTitleView.btnClicked(_:)), for: UIControlEvents.touchUpInside)
                if i == 0
                {
                    btn.setTitleColor(selectTextColor, for: UIControlState())
                }else{
                    btn.setTitleColor(normalTextColor, for: UIControlState())
                }
            }
        }
        
        var bio:CGFloat = 0.1
        if count == 2
        {
            bio = 0.25
        }
        if count == 3
        {
            bio = 0.2
        }
        
        let line = GetLineView(CGRect(x: 0, y: 39.5, width: GetSWidth(), height: 0.5))
        self.addSubview(line)
        line.isHidden = self.spacingLineHidden
        
        let lineHeight:CGFloat = 2
        lineView = UIView(frame: CGRect(x: leftSpacing, y: self.frame.size.height-lineHeight, width: width, height: lineHeight))
        blueLineView = UIView(frame: CGRect(x: width*bio, y: 0, width: width*(1-bio*2), height: lineHeight))
        blueLineView.backgroundColor = selectTextColor
        lineView.addSubview(blueLineView)
        self.addSubview(lineView)
        lineView.isHidden = count == 0 ? true : false
    }
    
    func btnClicked(_ btn:UIButton){
        if delegate == nil || !delegate!.responds(to: Selector("titleViewIndexDidSelected:index:"))
        {
            return
        }
        
        for i in 0 ..< btnArray.count
        {
            if btn.isEqual(btnArray[i])
            {
                delegate!.titleViewIndexDidSelected(self, index: i);
                return
            }
        }
    }
    
    func updateLine(_ f:CGFloat){
        curPos = f
        var frame = lineView.frame
        frame.origin.x = leftSpacing+(self.frame.size.width-leftSpacing-rightSpacing)*f
        lineView.frame = frame
        
        let e = CGFloat(1) / CGFloat(btnArray.count)
        
        let num = Int((f+e/2)/e)
        
        for i in 0 ..< btnArray.count
        {
            let btn = btnArray[i]
            if i == num
            {
                btn.setTitleColor(selectTextColor, for: UIControlState())
            }else{
                btn.setTitleColor(normalTextColor, for: UIControlState())
            }
        }
    }
}
