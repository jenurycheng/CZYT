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
    var leftArrow:UIImageView!
    var rightArrow:UIImageView!
    
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
        
        leftArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: ConditionBar.barHeight()))
        leftArrow.image = UIImage(named: "gradient_left")
        let left = UIImageView(frame: leftArrow.bounds)
        left.contentMode = .Center
        left.image = UIImage(named: "arrow_left")
        leftArrow.addSubview(left)
        self.addSubview(leftArrow)
        leftArrow.userInteractionEnabled = true
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(ConditionBar.leftTapped(_:)))
        leftArrow.addGestureRecognizer(leftTap)
        
        
        rightArrow = UIImageView(frame: CGRect(x: self.frame.width-40, y: 0, width: 40, height: ConditionBar.barHeight()))
        rightArrow.image = UIImage(named: "gradient_right")
        rightArrow.userInteractionEnabled = true
        let right = UIImageView(frame: rightArrow.bounds)
        right.image = UIImage(named: "arrow_right")
        right.contentMode = .Center
        rightArrow.addSubview(right)
        self.addSubview(rightArrow)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(ConditionBar.rightTapped(_:)))
        rightArrow.addGestureRecognizer(rightTap)
        
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
            let spacing:CGFloat = 25
            let titleWidth = Helper.getTextSize(title!, font: UIFont.systemFontOfSize(14), size: CGSizeMake(CGFloat(MAXFLOAT), ConditionBar.barHeight())).width
            titleBtn.frame = CGRectMake(15, 0, titleWidth+spacing, ConditionBar.barHeight())
            var x:CGFloat = titleBtn.frame.origin.x + titleBtn.frame.width
            if Helper.isStringEmpty(title) {
                x = 15
            }
            for i in 0 ..< textsArray!.count
            {
                let btn:UIButton = UIButton()
                btn.titleLabel?.font = UIFont.systemFontOfSize(14)
                var width = Helper.getTextSize(textsArray![i], font: btn.titleLabel!.font, size: CGSizeMake(CGFloat(MAXFLOAT), ConditionBar.barHeight())).width
                width+=spacing
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
            scrollView.contentSize = CGSizeMake(x+30, ConditionBar.barHeight())
            
            if x + 30 > GetSWidth() {
                leftArrow.hidden = false
                rightArrow.hidden = false
                
            }else{
                leftArrow.hidden = true
                rightArrow.hidden = true
            }
        }
    }
    
    func leftTapped(tap:UITapGestureRecognizer)
    {
        var x = scrollView.contentOffset.x
        x = x - 60
        if x < 0 {
            x = 0
        }
        scrollView.scrollRectToVisible(CGRectMake(x, 0, scrollView.frame.width, scrollView.frame.height), animated: true)
    }
    
    func rightTapped(tap:UITapGestureRecognizer)
    {
        var x = scrollView.contentOffset.x
        x = x + 60
        if x + 60 + scrollView.frame.width > scrollView.contentSize.width {
            x = scrollView.contentSize.width - scrollView.frame.width
        }
        scrollView.scrollRectToVisible(CGRectMake(x, 0, scrollView.frame.width, scrollView.frame.height), animated: true)
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
