//
//  UIImageView+GM.swift
//  GiMiHelper_3.0
//
//  Created by shuaidan on 16/8/9.
//  Copyright © 2016年 shuaidan. All rights reserved.
//

import Foundation

extension UIImageView
{
    func gm_setImageWithURL(url:NSURL?, placeholderImage:UIImage?, completedBlock:SDWebImageCompletionBlock)
    {
        self.sd_setImageWithURL(url, placeholderImage: placeholderImage, completed: completedBlock)
    }
    
    func gm_setImageWithURL(url:NSURL?, title:String?, completedBlock:SDWebImageCompletionBlock?)
    {
        let loadImage = Helper.imageWithLoading(self.bounds.size)
        self.sd_setImageWithURL(url, placeholderImage: loadImage) { (image, error, type, url) in
            
            if nil != error {
                let image = Helper.imageWithString(title, size: self.frame.size)
                self.image = image
            }
            if completedBlock != nil
            {
                completedBlock!(image, error, type, url)
            }
        }
    }
    
    func gm_setImageWithUrlString(urlString:String?, title:String?, completedBlock:SDWebImageCompletionBlock?)
    {
        if !Helper.isStringEmpty(urlString)
        {
            self.gm_setImageWithURL(NSURL(string: urlString!), title: title, completedBlock: completedBlock)
        }else{
            let image = Helper.imageWithString(title, size: self.frame.size)
            self.image = image
        }
    }
}
