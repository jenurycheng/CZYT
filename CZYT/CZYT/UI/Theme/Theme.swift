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
    var secMainColor:UIColor! = UIColor.white    //二级色调
    var blueColor:UIColor! = Helper.parseColor(0x4DB7F8FF)
    var navTitleColor:UIColor! = UIColor.white    //导航栏字体颜色
    var darkGrayFontColor:UIColor! = UIColor.darkGray
    var grayFontColor:UIColor! = UIColor.gray
    var lightGrayFontColor:UIColor = UIColor.lightGray
    var whiteFontColor:UIColor = UIColor.white
    var backgroundColor:UIColor! = UIColor.white  //背景色
    var foregroundColor:UIColor! = UIColor.white   // 前景色
}
