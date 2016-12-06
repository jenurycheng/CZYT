//
//  TaskResultViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/23.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskResultViewController: BasePortraitViewController {

    var taskDetail:TaskDetail?
    @IBOutlet weak var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ThemeManager.current().foregroundColor
        self.title = "提交结果"
        
        collectionView.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight() * 10)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(UINib(nibName: "TaskResultTopCell", bundle: nil), forCellWithReuseIdentifier: "TaskResultTopCell")
        collectionView.registerNib(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().foregroundColor
        collectionView.registerClass(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: UICollectionViewDelegate
extension TaskResultViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 1
        {
            let photoArray = NSMutableArray()
            
            for i in 0 ..< self.taskDetail!.task_comment!.photos!.count
            {
                let photo = MJPhoto()
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 1)) as! ImageCollectionCell
                photo.url = NSURL(string: self.taskDetail!.task_comment!.photos![i].photo_path!)
                photo.srcImageView = cell.imageView
                photo.image = cell.imageView.image
                photoArray.addObject(photo)
            }
            let browser = MJPhotoBrowser()
            browser.showPushBtn = false
            browser.currentPhotoIndex = UInt(indexPath.row)
            browser.photos = photoArray as [AnyObject]
            browser.show()
        }
    }
}

//MARK: UICollectionViewDataSource
extension TaskResultViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if taskDetail?.task_status == "accepted"
        {
            return 1
        }else{
            return 2
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UICollectionReusableView", forIndexPath: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 1 && indexPath.row == 0
            {
                cell.backgroundColor = ThemeManager.current().backgroundColor
            }
        }else{
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }else{
            return taskDetail?.task_comment?.photos?.count == nil ? 0 : taskDetail!.task_comment!.photos!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TaskResultTopCell", forIndexPath: indexPath) as! TaskResultTopCell
            cell.update(self.taskDetail!)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionCell", forIndexPath: indexPath) as! ImageCollectionCell
            cell.deleteBtn.hidden = true
            cell.updatePhoto(taskDetail!.task_comment!.photos![indexPath.row])
            return cell
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskResultViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return TaskResultTopCell.cellSize(self.taskDetail?.task_comment?.taskcomment_content)
        }else{
            return ImageCollectionCell.cellSize()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(10, 10, 10, 10)
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
        if section == 1
        {
            return CGSize(width: GetSWidth(), height: 1)
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeMake(GetSWidth(), 0)
    }
}