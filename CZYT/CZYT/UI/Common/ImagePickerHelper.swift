//
//  ImagePickerHelper.swift
//  GiMiHelper_New
//
//  Created by 成超 on 15/12/21.
//  Copyright © 2015年 XGIMI. All rights reserved.
//

import UIKit

class ImagePickerHelper: NSObject, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var callback:((images:NSArray)->Void)?
    var parentVC:UIViewController?
    var picker:UIImagePickerController?
    
    func show(vc:UIViewController, callback:((images:NSArray)->Void))
    {
        self.parentVC = vc
        self.callback = callback
        
        picker = UIImagePickerController()
        picker!.view.backgroundColor = ThemeManager.current().backgroundColor
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
        actionSheet.showInView(parentVC!.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        
        if buttonIndex == 1
        {
            print("拍照")
            self.selectFromCamera()
        }else if buttonIndex == 2
        {
            print("相册")
            self.selectFromPhoto()
        }
    }
    
    func selectFromPhoto()
    {
        picker?.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.delegate = self;
        picker?.allowsEditing = true
        
        parentVC?.presentViewController(picker!, animated: true, completion: nil)
    }
    
    func selectFromCamera()
    {
        picker?.sourceType = UIImagePickerControllerSourceType.Camera
        picker?.delegate = self;
        picker?.allowsEditing = true
        
        parentVC?.presentViewController(picker!, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        print(info)
        let image = info[UIImagePickerControllerEditedImage]
        if callback != nil
        {
            callback!(images: NSArray(object: image!))
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        print(String(image.size.width) + "===" + String(image.size.height))

    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
