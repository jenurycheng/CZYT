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
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.cgColor
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.register(UINib(nibName: "FileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FileCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().backgroundColor
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishTaskViewController.endEdit))
        
        self.uploadLabel.addGestureRecognizer(tap1)
        
        self.contentTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if ResourceDocumentFileView.selectedPath != nil {
            self.files.append(ResourceDocumentFileView.selectedPath!)
            ResourceDocumentFileView.selectedPath = nil
            self.collectionView.reloadData()
        }
    }
    
    override func backItemBarClicked(_ item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder
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
            MBProgressHUD.showMessag("请输入内容", to: self.view, showTimeSec: 1)
            return;
        }
        
        let hub = MBProgressHUD.showMessag("提交中", to: self.view)
        dataSource.finishTask(self.id!, text: text, photos: images, files: files, success: { (result) in
            hub?.hide(false)
            MBProgressHUD.showSuccess("提交成功", to: self.view.window)
            self.navigationController?.popViewController(animated: true)
            }) { (error) in
                MBProgressHUD.showError(error.msg, to: self.view)
                hub?.hide(false)
        }
    }

}

//MARK: UICollectionViewDelegate
extension SubmitTaskViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
            return
        }
        
        if indexPath.section == 0
        {
        
            if indexPath.row == images.count
            {
                let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "拍照", "相册")
                actionSheet.show(in: self.view)
            }else{
                let photoArray = NSMutableArray()
                
                for i in 0 ..< images.count
                {
                    let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! ImageCollectionCell
                    let photo = MJPhoto()
//                    photo.url = URL()
                    photo.srcImageView = cell.imageView
                    photo.image = images[i]
                    photoArray.add(photo)
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
                web.url = URL(fileURLWithPath: files[indexPath.row])
                self.navigationController?.pushViewController(web, animated: true)
            }
        }
    }
}

extension SubmitTaskViewController : UIActionSheetDelegate
{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        
        if buttonIndex == 1
        {
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.delegate = self;
            picker.allowsEditing = false
            
            self.present(picker, animated: true, completion: nil)
            
        }else if buttonIndex == 2
        {
            let picker = DNImagePickerController()
            picker.imagePickerDelegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
}

//MARK: UICollectionViewDataSource
extension SubmitTaskViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return images.count + 1
        }
        return files.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.delegate = self
            if indexPath.row < images.count
            {
                cell.updateView(images[indexPath.row])
                cell.deleteBtn.isHidden = false
            }else{
                cell.updateView(UIImage(named: "add_photo")!)
                cell.deleteBtn.isHidden = true
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionCell", for: indexPath) as! FileCollectionCell
            cell.delegate = self
            if indexPath.row < files.count
            {
                cell.update(files[indexPath.row])
                cell.deleteBtn.isHidden = false
            }else{
                cell.addBtn.setTitle("添加附件", for: UIControlState())
                cell.deleteBtn.isHidden = true
            }
            return cell
        }
    }
}

extension SubmitTaskViewController : ImageCollectionCellDelegate
{
    func deleteBtnClicked(_ cell: ImageCollectionCell) {
        let index = collectionView.indexPath(for: cell)
        images.remove(at: index!.row)
        collectionView.reloadData()
    }
}

extension SubmitTaskViewController : FileCollectionCellDelegate
{
    func fileDeleteBtnClicked(_ cell: FileCollectionCell) {
        let index = collectionView.indexPath(for: cell)
        files.remove(at: index!.row)
        collectionView.reloadData()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension SubmitTaskViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return ImageCollectionCell.cellSize()
        }else{
            return FileCollectionCell.cellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(20, 10, 20, 10)
        }else{
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        if section == 1
        {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: GetSWidth(), height: 0)
    }
}

extension SubmitTaskViewController : DNImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func dnImagePickerControllerDidCancel(_ imagePicker: DNImagePickerController!) {
        
    }
    
    func dnImagePickerController(_ imagePicker: DNImagePickerController!, sendImages imageAssets: [AnyObject]!, isFullImage fullImage: Bool) {
        for assets in imageAssets
        {
            ALAssetsLibrary().asset(for: assets.url, resultBlock: { (asset) in
                let image = UIImage(cgImage: (asset?.defaultRepresentation().fullScreenImage().takeUnretainedValue())!)
                self.images.append(image)
                self.collectionView.reloadData()
                }, failureBlock: { (error) in
                    
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.images.append(image)
        self.collectionView.reloadData()
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
