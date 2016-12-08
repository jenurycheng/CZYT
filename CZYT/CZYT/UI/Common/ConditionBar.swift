//
//  ConditionBar.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol ConditionBarDelegate : NSObjectProtocol
{
    func titleForConditionBar(conditionBar:ConditionBar)->String
    func textsForConditionBar(conditionBar:ConditionBar)->[String]
    func selectedIndexForConditionBar(conditionBar:ConditionBar)->Int    //返回－1:全部
    func didSelectedConditionBar(conditionBar:ConditionBar, index:Int)
}

class ConditionBar: UIView {

    static func barHeight()->CGFloat
    {
        return 40
    }
    
    var titleBtn:UIButton!
    var scrollView:UIScrollView!
    var selectedBtn:UIButton?
    var btnArray:NSMutableArray!
    var textsArray:Array<String>?
    var line:UIView!
    var cornerView:UIView!
    weak var delegate:ConditionBarDelegate?
        {
        didSet
        {
            self.loadView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCornerView(btnFrame:CGRect)
    {
        var frame = cornerView.frame
        frame.origin.x = btnFrame.origin.x
        frame.origin.y = (btnFrame.size.height - 30)/2
        frame.size.width = btnFrame.size.width
        UIView.animateWithDuration(0.2) { 
            self.cornerView.frame = frame
        }
    }
    
    func initView(){
        
        btnArray = NSMutableArray(capacity: 1)
        textsArray = Array<String>()
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.frame.size.width, ConditionBar.barHeight()))
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        
        titleBtn = UIButton(frame: CGRectMake(10, 0, 65, ConditionBar.barHeight()))
        titleBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        titleBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: UIControlState.Normal)
        scrollView.addSubview(titleBtn)
        titleBtn.addTarget(self, action: #selector(ConditionBar.titleBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        line = UIView(frame: CGRectMake(0, ConditionBar.barHeight()-0.5, GetSWidth(), 0.5))
        line.backgroundColor = ThemeManager.current().backgroundColor
        self.addSubview(line)
        
        cornerView = UIView(frame:CGRectMake(-100, 0, 100, 30))
        cornerView.layer.cornerRadius = 15
        cornerView.layer.borderWidth = 1
        cornerView.layer.borderColor = ThemeManager.current().mainColor.CGColor
//        scrollView.addSubview(cornerView)
    }
    
    func titleBtnClicked()
    {
        if delegate != nil
        {
            delegate?.didSelectedConditionBar(self, index: -1)
        }
        if selectedBtn != nil
        {
            selectedBtn?.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: UIControlState.Normal)
        }
        titleBtn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Normal)
        selectedBtn = titleBtn
        self.updateCornerView(titleBtn.frame)
    }
    
    func loadView(){
        for btn in btnArray
        {
            btn.removeFromSuperview()
        }
        btnArray.removeAllObjects()
        
        if delegate != nil
        {
            let title = delegate?.titleForConditionBar(self)
            titleBtn.setTitle(title, forState: UIControlState.Normal)
            textsArray = delegate?.textsForConditionBar(self)
            let selectedIndex = delegate?.selectedIndexForConditionBar(self)
            if selectedIndex < 0
            {
                titleBtn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Normal)
                selectedBtn = titleBtn
                self.updateCornerView(titleBtn.frame)
            }
            let titleWidth = Helper.getTextSize(title!, font: UIFont.systemFontOfSize(14), size: CGSizeMake(CGFloat(MAXFLOAT), ConditionBar.barHeight())).width
            titleBtn.frame = CGRectMake(10, 0, titleWidth, ConditionBar.barHeight())
            var x:CGFloat = titleWidth + 20
            if Helper.isStringEmpty(title) {
                x = 10
            }
            for i in 0 ..< textsArray!.count
            {
                let btn:UIButton = UIButton()
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                var width = Helper.getTextSize(textsArray![i], font: btn.titleLabel!.font, size: CGSizeMake(CGFloat(MAXFLOAT), ConditionBar.barHeight())).width
                width+=20
                btn.frame = CGRectMake(x, 0, width, ConditionBar.barHeight())
                x+=width
                btn.setTitle(textsArray![i], forState: UIControlState.Normal)
                btn.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: UIControlState.Normal)
                scrollView.addSubview(btn)
                btnArray.addObject(btn)
                if i == selectedIndex
                {
                    btn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Normal)
                    selectedBtn = btn
                    self.updateCornerView(btn.frame)
                }
                btn.addTarget(self, action: #selector(ConditionBar.btnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            }
            scrollView.contentSize = CGSizeMake(x, ConditionBar.barHeight())
        }
    }
    
    func btnClicked(btn:UIButton)
    {
        if selectedBtn != nil
        {
            selectedBtn?.setTitleColor(ThemeManager.current().darkGrayFontColor, forState: UIControlState.Normal)
        }
        btn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Normal)
        selectedBtn = btn
        self.updateCornerView(btn.frame)
        delegate?.didSelectedConditionBar(self, index: btnArray.indexOfObject(btn))
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
