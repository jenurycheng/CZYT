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
    var timer:Timer?
    
    static var single:LaunchAdverScreen?
    
    class func show()
    {
        if single == nil {
            single = LaunchAdverScreen(frame: UIScreen.main.bounds)
        }
        let w = UIApplication.shared.delegate?.window
        
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
    
    static let showTime = 3
    var count = LaunchAdverScreen.showTime
    func timeout(_ t:Timer)
    {
        count = count - 1
        if count == 0
        {
            t.invalidate()
            self.timer = nil
            self.close(true)
        }
        closeBtn.setTitle("跳过 \(count)", for: UIControlState())
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
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        
        closeBtn = UIButton(frame: CGRect(x: self.frame.width - 80, y: 20, width: 60, height: 30))
        closeBtn.setTitle("跳过", for: UIControlState())
        closeBtn.setTitleColor(ThemeManager.current().whiteFontColor, for: UIControlState())
        closeBtn.backgroundColor = Helper.parseColor(0x000000A0)
        closeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        closeBtn.layer.cornerRadius = 5
        closeBtn.layer.masksToBounds = true
        closeBtn.addTarget(self, action: #selector(LaunchAdverScreen.close), for: .touchUpInside)
        closeBtn.isHidden = true
//        self.addSubview(closeBtn)
        
        bottomImageView = UIImageView(frame: CGRect(x: 0, y: self.frame.height - (GetSWidth() / 320 * 71), width: GetSWidth(), height: GetSWidth() / 320 * 71))
        bottomImageView.isHidden = true
        bottomImageView.image = UIImage(named: "launch_bottom")
        self.addSubview(bottomImageView)
    }
    
    func loadImage()
    {
        count = LaunchAdverScreen.showTime
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LaunchAdverScreen.timeout(_:)), userInfo: nil, repeats: true)
        
        let imageName = "launch"
        self.imageView.image = UIImage(named: imageName)
    }
    
    func close(_ animate:Bool = true)
    {
        if animate
        {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: { (b) in
                self.removeFromSuperview()
                self.alpha = 1
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) 
        }else{
            self.removeFromSuperview()
        }
        
    }
}
