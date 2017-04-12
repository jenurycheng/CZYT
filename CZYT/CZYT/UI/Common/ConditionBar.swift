//
//  ConditionBar.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


protocol ConditionBarDelegate : NSObjectProtocol
{
    func titleForConditionBar(_ conditionBar:ConditionBar)->String
    func textsForConditionBar(_ conditionBar:ConditionBar)->[String]
    func selectedIndexForConditionBar(_ conditionBar:ConditionBar)->Int    //返回－1:全部
    func didSelectedConditionBar(_ conditionBar:ConditionBar, index:Int)
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
    
    func updateCornerView(_ btnFrame:CGRect)
    {
        var frame = cornerView.frame
        frame.origin.x = btnFrame.origin.x
        frame.origin.y = (btnFrame.size.height - 30)/2
        frame.size.width = btnFrame.size.width
        UIView.animate(withDuration: 0.2, animations: { 
            self.cornerView.frame = frame
        }) 
    }
    
    func initView(){
        
        btnArray = NSMutableArray(capacity: 1)
        textsArray = Array<String>()
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: ConditionBar.barHeight()))
        self.addSubview(scrollView)
        scrollView.showsHorizontalScrollIndicator = false
        
        leftArrow = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: ConditionBar.barHeight()))
        leftArrow.image = UIImage(named: "gradient_left")
        let left = UIImageView(frame: leftArrow.bounds)
        left.contentMode = .center
        left.image = UIImage(named: "arrow_left")
        leftArrow.addSubview(left)
        self.addSubview(leftArrow)
        leftArrow.isUserInteractionEnabled = true
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(ConditionBar.leftTapped(_:)))
        leftArrow.addGestureRecognizer(leftTap)
        
        
        rightArrow = UIImageView(frame: CGRect(x: self.frame.width-40, y: 0, width: 40, height: ConditionBar.barHeight()))
        rightArrow.image = UIImage(named: "gradient_right")
        rightArrow.isUserInteractionEnabled = true
        let right = UIImageView(frame: rightArrow.bounds)
        right.image = UIImage(named: "arrow_right")
        right.contentMode = .center
        rightArrow.addSubview(right)
        self.addSubview(rightArrow)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(ConditionBar.rightTapped(_:)))
        rightArrow.addGestureRecognizer(rightTap)
        
        titleBtn = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: ConditionBar.barHeight()))
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleBtn.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        scrollView.addSubview(titleBtn)
        titleBtn.addTarget(self, action: #selector(ConditionBar.titleBtnClicked), for: UIControlEvents.touchUpInside)
        
        line = UIView(frame: CGRect(x: 0, y: ConditionBar.barHeight()-0.5, width: GetSWidth(), height: 0.5))
        line.backgroundColor = ThemeManager.current().backgroundColor
        self.addSubview(line)
        
        cornerView = UIView(frame:CGRect(x: -100, y: 0, width: 100, height: 30))
        cornerView.layer.cornerRadius = 15
        cornerView.layer.borderWidth = 1
        cornerView.layer.borderColor = ThemeManager.current().mainColor.cgColor
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
            selectedBtn?.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        }
        titleBtn.setTitleColor(ThemeManager.current().mainColor, for: UIControlState())
        selectedBtn = titleBtn
        self.updateCornerView(titleBtn.frame)
    }
    
    func loadView(){
        for btn in btnArray
        {
            (btn as AnyObject).removeFromSuperview()
        }
        btnArray.removeAllObjects()
        
        if delegate != nil
        {
            let title = delegate?.titleForConditionBar(self)
            titleBtn.setTitle(title, for: UIControlState())
            textsArray = delegate?.textsForConditionBar(self)
            let selectedIndex = delegate?.selectedIndexForConditionBar(self)
            if selectedIndex < 0
            {
                titleBtn.setTitleColor(ThemeManager.current().mainColor, for: UIControlState())
                selectedBtn = titleBtn
                self.updateCornerView(titleBtn.frame)
            }
            let spacing:CGFloat = 25
            let titleWidth = Helper.getTextSize(title!, font: UIFont.systemFont(ofSize: 14), size: CGSize(width: CGFloat(MAXFLOAT), height: ConditionBar.barHeight())).width
            titleBtn.frame = CGRect(x: 15, y: 0, width: titleWidth+spacing, height: ConditionBar.barHeight())
            var x:CGFloat = titleBtn.frame.origin.x + titleBtn.frame.width
            if Helper.isStringEmpty(title) {
                x = 15
            }
            for i in 0 ..< textsArray!.count
            {
                let btn:UIButton = UIButton()
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                var width = Helper.getTextSize(textsArray![i], font: btn.titleLabel!.font, size: CGSize(width: CGFloat(MAXFLOAT), height: ConditionBar.barHeight())).width
                width+=spacing
                btn.frame = CGRect(x: x, y: 0, width: width, height: ConditionBar.barHeight())
                x+=width
                btn.setTitle(textsArray![i], for: UIControlState())
                btn.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
                scrollView.addSubview(btn)
                btnArray.add(btn)
                if i == selectedIndex
                {
                    btn.setTitleColor(ThemeManager.current().mainColor, for: UIControlState())
                    selectedBtn = btn
                    self.updateCornerView(btn.frame)
                }
                btn.addTarget(self, action: #selector(ConditionBar.btnClicked(_:)), for: UIControlEvents.touchUpInside)
            }
            scrollView.contentSize = CGSize(width: x+30, height: ConditionBar.barHeight())
            
            if x + 30 > GetSWidth() {
                leftArrow.isHidden = false
                rightArrow.isHidden = false
                
            }else{
                leftArrow.isHidden = true
                rightArrow.isHidden = true
            }
        }
    }
    
    func leftTapped(_ tap:UITapGestureRecognizer)
    {
        var x = scrollView.contentOffset.x
        x = x - 60
        if x < 0 {
            x = 0
        }
        scrollView.scrollRectToVisible(CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
    }
    
    func rightTapped(_ tap:UITapGestureRecognizer)
    {
        var x = scrollView.contentOffset.x
        x = x + 60
        if x + 60 + scrollView.frame.width > scrollView.contentSize.width {
            x = scrollView.contentSize.width - scrollView.frame.width
        }
        scrollView.scrollRectToVisible(CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height), animated: true)
    }
    
    func btnClicked(_ btn:UIButton)
    {
        if selectedBtn != nil
        {
            selectedBtn?.setTitleColor(ThemeManager.current().darkGrayFontColor, for: UIControlState())
        }
        btn.setTitleColor(ThemeManager.current().mainColor, for: UIControlState())
        selectedBtn = btn
        self.updateCornerView(btn.frame)
        delegate?.didSelectedConditionBar(self, index: btnArray.index(of: btn))
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
