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
        
        collectionView.frame = CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "TaskResultTopCell", bundle: nil), forCellWithReuseIdentifier: "TaskResultTopCell")
        collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().foregroundColor
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            let photoArray = NSMutableArray()
            
            for i in 0 ..< self.taskDetail!.task_comment!.photos!.count
            {
                let photo = MJPhoto()
                let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 1)) as! ImageCollectionCell
                photo.url = URL(string: self.taskDetail!.task_comment!.photos![i].photo_path!)
                photo.srcImageView = cell.imageView
                photo.image = cell.imageView.image
                photoArray.add(photo)
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
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if taskDetail?.task_status == "accepted"
        {
            return 1
        }else{
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 1 && indexPath.row == 0
            {
                cell.backgroundColor = ThemeManager.current().backgroundColor
            }
        }else{
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return 1
        }else{
            return taskDetail?.task_comment?.photos?.count == nil ? 0 : taskDetail!.task_comment!.photos!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskResultTopCell", for: indexPath) as! TaskResultTopCell
            cell.update(self.taskDetail!)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.deleteBtn.isHidden = true
            cell.updatePhoto(taskDetail!.task_comment!.photos![indexPath.row])
            return cell
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskResultViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return TaskResultTopCell.cellSize(self.taskDetail?.task_comment?.taskcomment_content)
        }else{
            return ImageCollectionCell.cellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 1
        {
            return CGSize(width: GetSWidth(), height: 1)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: GetSWidth(), height: 0)
    }
}
