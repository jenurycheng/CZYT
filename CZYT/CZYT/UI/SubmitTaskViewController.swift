//
//  SubmitTaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/22.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import AssetsLibrary

class SubmitTaskViewController: BasePortraitViewController {

    var id:String?
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var okBtn:UIButton!
    @IBOutlet weak var uploadLabel:UILabel!
    
    var dataSource = TaskDataSource()
    
    var images = [UIImage]()
    var files = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "提交任务"
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.text = ""
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.CGColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.registerNib(UINib(nibName: "FileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FileCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().backgroundColor
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        
        self.uploadLabel.addGestureRecognizer(tap1)
        
        self.contentTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if ResourceDocumentFileView.selectedPath != nil {
            self.files.append(ResourceDocumentFileView.selectedPath!)
            ResourceDocumentFileView.selectedPath = nil
            self.collectionView.reloadData()
        }
    }
    
    override func backItemBarClicked(item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder()
        {
            self.contentTextView.resignFirstResponder()
        }else{
            super.backItemBarClicked(item)
        }
    }
    
    func endEdit()
    {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtnClicked()
    {
     
        let text = contentTextView.text == nil ? "" : contentTextView.text!
        
        if Helper.isStringEmpty(text)
        {
            MBProgressHUD.showMessag("请输入内容", toView: self.view, showTimeSec: 1)
            return;
        }
        
        let hub = MBProgressHUD.showMessag("提交中", toView: self.view)
        dataSource.finishTask(self.id!, text: text, photos: images, files: files, success: { (result) in
            hub.hide(false)
            MBProgressHUD.showSuccess("提交成功", toView: self.view.window)
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                MBProgressHUD.showError(error.msg, toView: self.view)
                hub.hide(false)
        }
    }

}

//MARK: UICollectionViewDelegate
extension SubmitTaskViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if contentTextView.isFirstResponder() {
            contentTextView.resignFirstResponder()
            return
        }
        
        if indexPath.section == 0
        {
        
            if indexPath.row == images.count
            {
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
                actionSheet.showInView(self.view)
            }else{
                let photoArray = NSMutableArray()
                
                for i in 0 ..< images.count
                {
                    let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 0)) as! ImageCollectionCell
                    let photo = MJPhoto()
                    photo.url = NSURL()
                    photo.srcImageView = cell.imageView
                    photo.image = images[i]
                    photoArray.addObject(photo)
                }
                let browser = MJPhotoBrowser()
                browser.showPushBtn = false
                browser.currentPhotoIndex = UInt(indexPath.row)
                browser.photos = photoArray as [AnyObject]
                browser.show()
            }
        }else{
            if indexPath.row == files.count
            {
                let select = SelectFileViewController()
                self.navigationController?.pushViewController(select, animated: true)
            }else{
                //browse
                let web = WebShowViewController()
                web.url = NSURL.fileURLWithPath(files[indexPath.row])
                self.navigationController?.pushViewController(web, animated: true)
            }
        }
    }
}

extension SubmitTaskViewController : UIActionSheetDelegate
{
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        
        if buttonIndex == 1
        {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self;
            picker.allowsEditing = false
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        }else if buttonIndex == 2
        {
            let picker = DNImagePickerController()
            picker.imagePickerDelegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }
    }
}

//MARK: UICollectionViewDataSource
extension SubmitTaskViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return images.count + 1
        }
        return files.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionCell", forIndexPath: indexPath) as! ImageCollectionCell
            cell.delegate = self
            if indexPath.row < images.count
            {
                cell.updateView(images[indexPath.row])
                cell.deleteBtn.hidden = false
            }else{
                cell.updateView(UIImage(named: "add_photo")!)
                cell.deleteBtn.hidden = true
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FileCollectionCell", forIndexPath: indexPath) as! FileCollectionCell
            cell.delegate = self
            if indexPath.row < files.count
            {
                cell.update(files[indexPath.row])
                cell.deleteBtn.hidden = false
            }else{
                cell.addBtn.setTitle("添加附件", forState: .Normal)
                cell.deleteBtn.hidden = true
            }
            return cell
        }
    }
}

extension SubmitTaskViewController : ImageCollectionCellDelegate
{
    func deleteBtnClicked(cell: ImageCollectionCell) {
        let index = collectionView.indexPathForCell(cell)
        images.removeAtIndex(index!.row)
        collectionView.reloadData()
    }
}

extension SubmitTaskViewController : FileCollectionCellDelegate
{
    func fileDeleteBtnClicked(cell: FileCollectionCell) {
        let index = collectionView.indexPathForCell(cell)
        files.removeAtIndex(index!.row)
        collectionView.reloadData()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SubmitTaskViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return ImageCollectionCell.cellSize()
        }else{
            return FileCollectionCell.cellSize()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(20, 10, 20, 10)
        }else{
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        if section == 1
        {
            return 5
        }
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeMake(GetSWidth(), 0)
    }
}

extension SubmitTaskViewController : DNImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func dnImagePickerControllerDidCancel(imagePicker: DNImagePickerController!) {
        
    }
    
    func dnImagePickerController(imagePicker: DNImagePickerController!, sendImages imageAssets: [AnyObject]!, isFullImage fullImage: Bool) {
        for assets in imageAssets
        {
            ALAssetsLibrary().assetForURL(assets.url, resultBlock: { (asset) in
                let image = UIImage(CGImage: asset.defaultRepresentation().fullScreenImage().takeUnretainedValue())
                self.images.append(image)
                self.collectionView.reloadData()
                }, failureBlock: { (error) in
                    
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.images.append(image)
        self.collectionView.reloadData()
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
