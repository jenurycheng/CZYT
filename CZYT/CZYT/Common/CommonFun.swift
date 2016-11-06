//
//  CommonFun.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import Foundation
import UIKit

var ISDebug = true

let ISSDPrint = true
let ISCCPrint = true

func SDPrint(str:Any...) {
    if ISSDPrint && ISDebug {
        debugPrint("sd:", str)
    }
}

func CCPrint(str:Any...) {
    
    if ISCCPrint && ISDebug {
        debugPrint("cc:", str)
    }
}

func GetLocalizedStr(key:String, isLocalizable:Bool = true, comment:String = "") -> String {
    
    if isLocalizable {
        return NSLocalizedString(key, comment: comment)
    }
    return NSLocalizedString(key, comment: comment)
}

func GetSWidth()->CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

func GetSHeight()->CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

func GetLineView(frame:CGRect, color:UIColor = Helper.parseColor(0xE0E0E0FF))->UIView
{
    let line = UIView(frame: frame)
    line.backgroundColor = color
    return line
}

func DispatchAfter(sec:Float, queue:dispatch_queue_t, block:dispatch_block_t)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Float(NSEC_PER_SEC) * sec)), queue, block)
}


