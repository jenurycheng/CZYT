//
//  Theme.swift
//  GiMiHelper_3.0
//
//  Created by shuaidan on 16/8/8.
//  Copyright © 2016年 shuaidan. All rights reserved.
//

import UIKit

class Theme: NSObject {
    var mainColor:UIColor! = UIColor(white: 0.28, alpha: 1)   //主色调
    var secMainColor:UIColor! = UIColor.whiteColor()    //二级色调
    var blueColor:UIColor! = Helper.parseColor(0x4DB7F8FF)
    var navTitleColor:UIColor! = UIColor.whiteColor()    //导航栏字体颜色
    var darkGrayFontColor:UIColor! = UIColor.darkGrayColor()
    var grayFontColor:UIColor! = UIColor.grayColor()
    var lightGrayFontColor:UIColor = UIColor.lightGrayColor()
    var whiteFontColor:UIColor = UIColor.whiteColor()
    var backgroundColor:UIColor! = UIColor.whiteColor()  //背景色
    var foregroundColor:UIColor! = UIColor.whiteColor()   // 前景色
}
