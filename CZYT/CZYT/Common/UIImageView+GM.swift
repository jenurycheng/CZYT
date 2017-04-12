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
    func gm_setImageWithURL(_ url:URL?, placeholderImage:UIImage?, completedBlock:SDWebImageCompletionBlock?)
    {
        //        self.sd_setImage(with: url, placeholderImage: placeholderImage, completed: completedBlock)
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions(), completed: completedBlock)
    }
    
    func gm_setImageWithURL(_ url:URL?, title:String?, completedBlock:SDWebImageCompletionBlock?)
    {
        let loadImage = Helper.imageWithLoading(self.bounds.size)
        self.sd_setImage(with: url, placeholderImage: loadImage, options: SDWebImageOptions()) { (image, error, type, url) in
            if nil != error {
                let image = Helper.imageWithString(" ", size: self.frame.size)
                self.image = image
            }
            if completedBlock != nil
            {
                completedBlock!(image, error, type, url)
            }
        }
    }
    
    func gm_setImageWithUrlString(_ urlString:String?, title:String?, completedBlock:SDWebImageCompletionBlock?)
    {
        if !Helper.isStringEmpty(urlString)
        {
            self.gm_setImageWithURL(URL(string: urlString!), title: title, completedBlock: completedBlock)
        }else{
            let image = Helper.imageWithString(title, size: self.frame.size)
            self.image = image
        }
    }
}
