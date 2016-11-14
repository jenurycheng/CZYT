//
//  NSMutableAttributedString+Utils.swift
//  GiMiHelper_Kid
//
//  Created by 成超 on 7/14/16.
//  Copyright © 2016 成超. All rights reserved.
//

import UIKit

extension NSMutableAttributedString
{
    func appendAttributeString(string:String, color:UIColor, font:UIFont, lineSpacing:CGFloat? = nil)
    {
        let newString = NSMutableAttributedString(string: string)
        let newLength = string.characters.count
        newString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, newLength))
        newString.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, newLength))
        
        
        if lineSpacing != nil {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing!
            newString.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, newString.length))
        }
        
        self.appendAttributedString(newString)
        
        
    }
}