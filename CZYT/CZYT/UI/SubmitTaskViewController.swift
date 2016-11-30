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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "提交任务"
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.CGColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().backgroundColor
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        
        self.uploadLabel.addGestureRecognizer(tap1)
        // Do any additional setup after loading the view.
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
        let hub = MBProgressHUD.showMessag("提交中", toView: self.view)
        let text = contentTextView.text == nil ? "" : contentTextView.text!
        dataSource.finishTask(self.id!, text: text, photos: images, success: { (result) in
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
        if indexPath.row == images.count
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
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
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

//MARK: UICollectionViewDelegateFlowLayout
extension SubmitTaskViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return ImageCollectionCell.cellSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(20, 10, 20, 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
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

extension SubmitTaskViewController : DNImagePickerControllerDelegate
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
}