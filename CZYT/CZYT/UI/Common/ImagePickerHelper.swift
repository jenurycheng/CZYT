//
//  ImagePickerHelper.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ImagePickerHelper: NSObject, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var callback:((_ images:NSArray)->Void)?
    var parentVC:UIViewController?
    var picker:UIImagePickerController?
    
    func show(_ vc:UIViewController, callback:@escaping ((_ images:NSArray)->Void))
    {
        self.parentVC = vc
        self.callback = callback
        
        picker = UIImagePickerController()
        picker!.view.backgroundColor = ThemeManager.current().backgroundColor
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
        actionSheet.show(in: parentVC!.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
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
        picker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker?.delegate = self;
        picker?.allowsEditing = true
        
        parentVC?.present(picker!, animated: true, completion: nil)
    }
    
    func selectFromCamera()
    {
        picker?.sourceType = UIImagePickerControllerSourceType.camera
        picker?.delegate = self;
        picker?.allowsEditing = true
        
        parentVC?.present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        let image = info[UIImagePickerControllerEditedImage]
        if callback != nil
        {
            callback!(NSArray(object: image!))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismiss(animated: true, completion: nil)
        print(String(describing: image.size.width) + "===" + String(describing: image.size.height))

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}
