//
//  CCPageView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

@objc protocol CCPageViewDelegate : NSObjectProtocol
{
    func pageCountForPageView(_ page:CCPageView)->Int
    func pageViewForIndex(_ page:CCPageView, index:Int)->UIView
    @objc optional func pageClickedAtIndex(_ page:CCPageView, index:Int)
}

class CCPageView: UIView, UIGestureRecognizerDelegate {

    static func viewHeight()->CGFloat{
        return GetSWidth() * 4/7.0 + 15
//        return Helper.scale(545) 7:3
    }

//    static var viewHeight:CGFloat = 135
    var beginTime:Double! = 0.0
    var pageCount:Int! = 0
    var viewArray:Array<UIView>!
    var pageContainer:UIView!
    var pageControl:UIPageControl!
    var timer:Timer!
    var duration:TimeInterval = 4
    var edge:CGFloat = 1.0
    
    var curPage:Int! = 0
        {
        didSet
        {
            if pageControl != nil
            {
                pageControl.currentPage = curPage
            }
        }
    }
    
    weak var delegate:CCPageViewDelegate?
    {
        didSet
        {
            self.loadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        viewArray = Array<UIView>()

        pageContainer = UIView(frame: self.bounds)
        self.addSubview(pageContainer)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.frame.size.height-15, width: self.frame.size.width, height: 15))
        pageControl.numberOfPages = pageCount
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = ThemeManager.current().mainColor
        self.addSubview(pageControl)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CCPageView.panned(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        if timer != nil
        {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CCPageView.tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    var startPoint:CGPoint?
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool
    {
        startPoint = touch.location(in: self)
        print("true")
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p = gestureRecognizer.location(in: self)
        if abs(startPoint!.x - p.x) > abs(startPoint!.y - p.y)
        {
            return true
        }
        return false
    }
    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool
//    {
//        if otherGestureRecognizer.view!.isKindOfClass(UITableView.classForCoder())
//        {
//            return true
//        }
//        return false
//    }
    
    func startAnimate(){
        if timer != nil
        {
            timer.invalidate()
            timer = nil
        }
        if timer == nil
        {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func stopAnimate(){
        if timer != nil
        {
            timer.invalidate()
            timer = nil
        }
    }
    
    func tapped(_ tap:UITapGestureRecognizer){
        if delegate != nil && pageCount > 0 && viewArray[curPage].frame.origin.x == 0
        {
            if delegate!.responds(to: #selector(CCPageViewDelegate.pageClickedAtIndex(_:index:)))
            {
                self.delegate!.pageClickedAtIndex!(self, index: self.curPage)
            }
        }
    }
    
    func timeOut(_ timer:Timer)
    {
        if delegate == nil || pageCount == 0 || pageCount == 1
        {
            return
        }
        
        let nextPage = (curPage+1)%pageCount
        let nextView = viewArray[nextPage]
        nextView.frame = CGRect(x: pageContainer.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.scrollToNext(1.2)
    }
    
    func panned(_ pan:UIPanGestureRecognizer){
        
        if pageCount == 0
        {
            return
        }
        if pan.state == UIGestureRecognizerState.began
        {
            if timer != nil
            {
                timer.invalidate()
                timer = nil
            }
            let date = Date()
            beginTime = date.timeIntervalSince1970
        }
        
        let p = pan.translation(in: self)
      //  print(String(p.x) + "===" + String(p.y))
        
        if pan.state == UIGestureRecognizerState.changed
        {
            if p.x < 0
            {
                let nextPage = (curPage+1)%pageCount
                let nextView = viewArray[nextPage]
                
                pageContainer.bringSubview(toFront: nextView)
                nextView.frame = CGRect(x: self.frame.size.width+p.x, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                
                let curView = viewArray[curPage]
                curView.frame = CGRect(x: p.x/edge, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }else if p.x > 0
            {
                let prePage = (pageCount+curPage-1)%pageCount
                let preView = viewArray[prePage]
                
                pageContainer.bringSubview(toFront: preView)
                preView.frame = CGRect(x: p.x-self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                
                let curView = viewArray[curPage]
                curView.frame = CGRect(x: p.x/edge, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }
        }
        
        if pan.state == UIGestureRecognizerState.ended
        {
            //print("end")
            if timer != nil
            {
                timer.invalidate()
                timer = nil
            }
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
            let date = Date()
            let endTime = date.timeIntervalSince1970
            let time = endTime-beginTime
            if p.x < -50
            {
                self.scrollToNext(time)
            }else if(p.x > 50)
            {
                self.scrollToPrevious(time)
            }else
            {
                if p.x > 0
                {
                    self.restoreToLeft()
                }else if p.x < 0
                {
                    self.restoreToRight()
                }
            }
        }
    }
    
    func restoreToRight(){
        let curView = viewArray[curPage]
        let nextPage = (curPage+1)%pageCount
        let nextView = viewArray[nextPage]
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            curView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            if !curView.isEqual(nextView)
            {
                nextView.frame = CGRect(x: self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }
            }, completion: { (b:Bool) -> Void in
                self.pageContainer.bringSubview(toFront: curView)
        }) 
    }
    
    func restoreToLeft(){
        let curView = viewArray[curPage]
        let prePage = (pageCount+curPage-1)%pageCount
        let preView = viewArray[prePage]
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            curView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            if !curView.isEqual(preView)
            {
                preView.frame = CGRect(x: -self.frame.size.width, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            }
            }, completion: { (b:Bool) -> Void in
                self.pageContainer.bringSubview(toFront: curView)
        }) 
    }
    
    func scrollToNext(_ time:Double){
        let curView = viewArray[curPage]
        let nextPage = (curPage+1)%pageCount
        let nextView = viewArray[nextPage]
        pageContainer.bringSubview(toFront: nextView)
        var base:Double! = 1.0
        if time >= 0.3 && time < 2
        {
            base = time
        }
        if time < 0.3
        {
            base = 0.3
        }
        let dur = base * Double(nextView.frame.origin.x/nextView.frame.size.width)
        UIView.animate(withDuration: Double(dur), animations: { () -> Void in
            curView.frame = CGRect(x: -self.frame.size.width/self.edge, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            nextView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: { (b:Bool) -> Void in
            curView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.pageContainer.bringSubview(toFront: nextView)
            self.curPage = nextPage
        }) 
    }
    
    func scrollToPrevious(_ time:Double){
        let curView = viewArray[curPage]
        let prePage = (pageCount+curPage-1)%pageCount
        let preView = viewArray[prePage]
        var base:Double! = 1.0
        if time < 1.0
        {
            base = time
        }
        if time < 0.3
        {
            base = 0.3
        }
        pageContainer.bringSubview(toFront: preView)
        let dur = base * Double(-preView.frame.origin.x/curView.frame.size.width)
        UIView.animate(withDuration: Double(dur), animations: { () -> Void in
            curView.frame = CGRect(x: self.frame.size.width/self.edge, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            preView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: { (b:Bool) -> Void in
            curView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
            self.pageContainer.bringSubview(toFront: preView)
            self.curPage = prePage
        }) 
    }
    
    func loadData(){
        if delegate != nil
        {
            curPage = 0
            for v in viewArray
            {
                v.removeFromSuperview()
            }
            viewArray.removeAll(keepingCapacity: false)
            pageCount = delegate!.pageCountForPageView(self)
            pageControl.numberOfPages = pageCount
            for i in 0 ..< pageCount
            {
                let view = delegate!.pageViewForIndex(self, index:i)
                view.backgroundColor = ThemeManager.current().backgroundColor
                viewArray.append(view)
                pageContainer.addSubview(view)
            }
            if pageCount > 0
            {
                pageContainer.bringSubview(toFront: viewArray[0])
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(3 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) { () -> Void in
                self.startAnimate()
            }
        }
    }
}
