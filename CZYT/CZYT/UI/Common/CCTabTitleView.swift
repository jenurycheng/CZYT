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
    func titleForPosition(pos:NSInteger)->String!
    func titleViewIndexDidSelected(titleView:CCTabTitleView, index:Int)
}

class CCTabTitleView: UIView {
    weak var delegate:CCTabTitleViewDelegate?
        {
        didSet{
            self.reloadView()
        }
    }
    
    var font:UIFont?
    var textArray:Array<String!>!
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
    
    func setDelegate(delegate:CCTabTitleViewDelegate){
        self.delegate = delegate
        self.reloadView()
    }
    
    func resetView()
    {
        for i in self.subviews
        {
            i.removeFromSuperview()
        }
        textArray.removeAll(keepCapacity: false)
        btnArray.removeAll(keepCapacity: false)
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
                let btn:UIButton! = UIButton(frame: CGRectMake(leftSpacing+width*CGFloat(i), 0, width, self.frame.size.height-2))
                btn.setTitle(text, forState: UIControlState.Normal)
                btn.setTitleColor(selectTextColor, forState: UIControlState.Normal)
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                if font != nil
                {
                    btn.titleLabel?.font = font
                }
                self.addSubview(btn)
                btnArray.append(btn)
                btn.addTarget(self, action: #selector(CCTabTitleView.btnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                if i == 0
                {
                    btn.setTitleColor(selectTextColor, forState: UIControlState.Normal)
                }else{
                    btn.setTitleColor(normalTextColor, forState: UIControlState.Normal)
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
        
        let line = GetLineView(CGRectMake(0, 39.5, GetSWidth(), 0.5))
        self.addSubview(line)
        line.hidden = self.spacingLineHidden
        
        let lineHeight:CGFloat = 2
        lineView = UIView(frame: CGRectMake(leftSpacing, self.frame.size.height-lineHeight, width, lineHeight))
        blueLineView = UIView(frame: CGRectMake(width*bio, 0, width*(1-bio*2), lineHeight))
        blueLineView.backgroundColor = selectTextColor
        lineView.addSubview(blueLineView)
        self.addSubview(lineView)
        lineView.hidden = count == 0 ? true : false
    }
    
    func btnClicked(btn:UIButton){
        if delegate == nil || !delegate!.respondsToSelector(Selector("titleViewIndexDidSelected:index:"))
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
    
    func updateLine(f:CGFloat){
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
                btn.setTitleColor(selectTextColor, forState: UIControlState.Normal)
            }else{
                btn.setTitleColor(normalTextColor, forState: UIControlState.Normal)
            }
        }
    }
}
