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

func SDPrint(_ str:Any...) {
    if ISSDPrint && ISDebug {
        debugPrint("sd:", str)
    }
}

func CCPrint(_ str:Any...) {
    
    if ISCCPrint && ISDebug {
        debugPrint("cc:", str)
    }
}

func GetLocalizedStr(_ key:String, isLocalizable:Bool = true, comment:String = "") -> String {
    
    if isLocalizable {
        return NSLocalizedString(key, comment: comment)
    }
    return NSLocalizedString(key, comment: comment)
}

func GetSWidth()->CGFloat {
    return UIScreen.main.bounds.size.width
}

func GetSHeight()->CGFloat {
    return UIScreen.main.bounds.size.height
}

func GetLineView(_ frame:CGRect, color:UIColor = Helper.parseColor(0xE0E0E0FF))->UIView
{
    let line = UIView(frame: frame)
    line.backgroundColor = color
    return line
}

func DispatchAfter(_ sec:Float, queue:DispatchQueue, block:@escaping ()->())
{
    queue.asyncAfter(deadline: DispatchTime.now() + Double(Int64(Float(NSEC_PER_SEC) * sec)) / Double(NSEC_PER_SEC), execute: block)
}


