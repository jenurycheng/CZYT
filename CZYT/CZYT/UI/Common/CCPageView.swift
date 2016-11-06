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
    func pageCountForPageView(page:CCPageView)->Int
    func pageViewForIndex(page:CCPageView, index:Int)->UIView
    optional func pageClickedAtIndex(page:CCPageView, index:Int)
}

class CCPageView: UIView, UIGestureRecognizerDelegate {

    static func viewHeight()->CGFloat{
        return GetSWidth() * 3.0/7.0
//        return Helper.scale(545) 7:3
    }

//    static var viewHeight:CGFloat = 135
    var beginTime:Double! = 0.0
    var pageCount:Int! = 0
    var viewArray:Array<UIView>!
    var pageContainer:UIView!
    var pageControl:UIPageControl!
    var timer:NSTimer!
    var duration:NSTimeInterval = 4
    
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
        
        pageControl = UIPageControl(frame: CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20))
        pageControl.numberOfPages = pageCount
        self.addSubview(pageControl)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(CCPageView.panned(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        if timer != nil
        {
            timer.invalidate()
            timer = nil
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CCPageView.tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    var startPoint:CGPoint?
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool
    {
        startPoint = touch.locationInView(self)
        print("true")
        return true
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        let p = gestureRecognizer.locationInView(self)
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
            timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
        }
    }
    
    func stopAnimate(){
        if timer != nil
        {
            timer.invalidate()
            timer = nil
        }
    }
    
    func tapped(tap:UITapGestureRecognizer){
        if delegate != nil && pageCount > 0 && viewArray[curPage].frame.origin.x == 0
        {
            if delegate!.respondsToSelector(#selector(CCPageViewDelegate.pageClickedAtIndex(_:index:)))
            {
                self.delegate!.pageClickedAtIndex!(self, index: self.curPage)
            }
        }
    }
    
    func timeOut(timer:NSTimer)
    {
        if delegate == nil || pageCount == 0 || pageCount == 1
        {
            return
        }
        
        let nextPage = (curPage+1)%pageCount
        let nextView = viewArray[nextPage]
        nextView.frame = CGRectMake(pageContainer.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
        self.scrollToNext(1.2)
    }
    
    func panned(pan:UIPanGestureRecognizer){
        
        if pageCount == 0
        {
            return
        }
        if pan.state == UIGestureRecognizerState.Began
        {
            if timer != nil
            {
                timer.invalidate()
                timer = nil
            }
            let date = NSDate()
            beginTime = date.timeIntervalSince1970
        }
        
        let p = pan.translationInView(self)
      //  print(String(p.x) + "===" + String(p.y))
        
        if pan.state == UIGestureRecognizerState.Changed
        {
            if p.x < 0
            {
                let nextPage = (curPage+1)%pageCount
                let nextView = viewArray[nextPage]
                
                pageContainer.bringSubviewToFront(nextView)
                nextView.frame = CGRectMake(self.frame.size.width+p.x, 0, self.frame.size.width, self.frame.size.height)
                
                let curView = viewArray[curPage]
                curView.frame = CGRectMake(p.x/2, 0, self.frame.size.width, self.frame.size.height)
            }else if p.x > 0
            {
                let prePage = (pageCount+curPage-1)%pageCount
                let preView = viewArray[prePage]
                
                pageContainer.bringSubviewToFront(preView)
                preView.frame = CGRectMake(p.x-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
                
                let curView = viewArray[curPage]
                curView.frame = CGRectMake(p.x/2, 0, self.frame.size.width, self.frame.size.height)
            }
        }
        
        if pan.state == UIGestureRecognizerState.Ended
        {
            //print("end")
            if timer != nil
            {
                timer.invalidate()
                timer = nil
            }
            timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: #selector(CCPageView.timeOut(_:)), userInfo: nil, repeats: true)
            let date = NSDate()
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
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            curView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            if !curView.isEqual(nextView)
            {
                nextView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
            }
            }) { (b:Bool) -> Void in
                self.pageContainer.bringSubviewToFront(curView)
        }
    }
    
    func restoreToLeft(){
        let curView = viewArray[curPage]
        let prePage = (pageCount+curPage-1)%pageCount
        let preView = viewArray[prePage]
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            curView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            if !curView.isEqual(preView)
            {
                preView.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
            }
            }) { (b:Bool) -> Void in
                self.pageContainer.bringSubviewToFront(curView)
        }
    }
    
    func scrollToNext(time:Double){
        let curView = viewArray[curPage]
        let nextPage = (curPage+1)%pageCount
        let nextView = viewArray[nextPage]
        pageContainer.bringSubviewToFront(nextView)
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
        UIView.animateWithDuration(Double(dur), animations: { () -> Void in
            curView.frame = CGRectMake(-self.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height)
            nextView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        }) { (b:Bool) -> Void in
            curView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.pageContainer.bringSubviewToFront(nextView)
            self.curPage = nextPage
        }
    }
    
    func scrollToPrevious(time:Double){
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
        pageContainer.bringSubviewToFront(preView)
        let dur = base * Double(-preView.frame.origin.x/curView.frame.size.width)
        UIView.animateWithDuration(Double(dur), animations: { () -> Void in
            curView.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height)
            preView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        }) { (b:Bool) -> Void in
            curView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.pageContainer.bringSubviewToFront(preView)
            self.curPage = prePage
        }
    }
    
    func loadData(){
        if delegate != nil
        {
            curPage = 0
            for v in viewArray
            {
                v.removeFromSuperview()
            }
            viewArray.removeAll(keepCapacity: false)
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
                pageContainer.bringSubviewToFront(viewArray[0])
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                self.startAnimate()
            }
        }
    }
}
