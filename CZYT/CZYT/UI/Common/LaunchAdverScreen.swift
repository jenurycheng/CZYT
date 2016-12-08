//
//  LaunchAdverScreen.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LaunchAdverScreen: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var imageView:UIImageView!
    var closeBtn:UIButton!
    var bottomImageView:UIImageView!
    var timer:NSTimer?
    
    static var single:LaunchAdverScreen?
    
    class func show()
    {
        if single == nil {
            single = LaunchAdverScreen(frame: UIScreen.mainScreen().bounds)
        }
        let w = UIApplication.sharedApplication().delegate?.window
        
        if w != nil
        {
            w!?.addSubview(single!)
            single?.loadImage()
        }
    }
    
    class func isShow()->Bool
    {
        return single?.superview == nil ? false : true
    }
    
    var count = 3
    func timeout(t:NSTimer)
    {
        count = count - 1
        if count == 0
        {
            t.invalidate()
            self.timer = nil
            self.close(true)
        }
        closeBtn.setTitle("跳过 \(count)", forState: .Normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        
        closeBtn = UIButton(frame: CGRect(x: self.frame.width - 80, y: 20, width: 60, height: 30))
        closeBtn.setTitle("跳过", forState: .Normal)
        closeBtn.setTitleColor(ThemeManager.current().whiteFontColor, forState: .Normal)
        closeBtn.backgroundColor = Helper.parseColor(0x000000A0)
        closeBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        closeBtn.layer.cornerRadius = 5
        closeBtn.layer.masksToBounds = true
        closeBtn.addTarget(self, action: #selector(LaunchAdverScreen.close), forControlEvents: .TouchUpInside)
        closeBtn.hidden = true
//        self.addSubview(closeBtn)
        
        bottomImageView = UIImageView(frame: CGRect(x: 0, y: self.frame.height - (GetSWidth() / 320 * 71), width: GetSWidth(), height: GetSWidth() / 320 * 71))
        bottomImageView.hidden = true
        bottomImageView.image = UIImage(named: "launch_bottom")
        self.addSubview(bottomImageView)
    }
    
    func loadImage()
    {
        count = 3
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LaunchAdverScreen.timeout(_:)), userInfo: nil, repeats: true)
        
        let imageName = "launch"
        self.imageView.image = UIImage(named: imageName)
    }
    
    func close(animate:Bool = true)
    {
        if animate
        {
            UIView.animateWithDuration(0.2, animations: {
                self.alpha = 0
                self.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }) { (b) in
                self.removeFromSuperview()
                self.alpha = 1
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }
        }else{
            self.removeFromSuperview()
        }
        
    }
}
