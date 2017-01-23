//
//  NoDataView.swift
//  GiMiHelper_New
//
//  Created by 成超 on 15/12/25.
//  Copyright © 2015年 XGIMI. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    var hintText:String! = "暂无数据"
    var imageName:String! = ""
    var hintDetailLabel:UILabel!
        
    init(frame: CGRect, imageName:String, hintText:String) {
        super.init(frame: frame)
        self.imageName = imageName
        self.hintText = hintText
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        
        self.backgroundColor = ThemeManager.current().backgroundColor
        
        let centerView = UIView(frame: CGRectMake(0, Helper.scale(500), self.frame.size.width, Helper.scale(700)))
//        centerView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 50)
        self.addSubview(centerView)
        
        let imageView = UIImageView(frame: CGRectMake(centerView.frame.size.width/2-Helper.scale(200), 0, Helper.scale(400), Helper.scale(400)))
        imageView.image = UIImage(named: imageName)
        centerView.addSubview(imageView)
        
        hintDetailLabel = UILabel(frame: CGRectMake(0, Helper.scale(480), centerView.frame.size.width, 60))
        hintDetailLabel.textAlignment = NSTextAlignment.Center
        hintDetailLabel.textColor = ThemeManager.current().grayFontColor
        hintDetailLabel.text = hintText
        hintDetailLabel.numberOfLines = 3
        hintDetailLabel.font = UIFont.systemFontOfSize(15)
        centerView.addSubview(hintDetailLabel)
    }
}
