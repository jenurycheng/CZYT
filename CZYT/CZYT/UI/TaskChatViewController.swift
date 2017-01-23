//
//  TaskChatViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/20.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TaskChatViewController: BasePortraitViewController {

    var collectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "督办交流"
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()//ThemeManager.current().foregroundColor
        collectionView.registerNib(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.registerClass(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        self.view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UICollectionViewDelegate
extension TaskChatViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                let new = PublishTaskViewController(nibName: "PublishTaskViewController", bundle: nil)
                self.navigationController?.pushViewController(new, animated: true)
            }else if indexPath.row == 1
            {
                let my = MyPublishTaskViewController()
                self.navigationController?.pushViewController(my, animated: true)
            }else if indexPath.row == 2
            {
                let my = MyTaskViewController()
                self.navigationController?.pushViewController(my, animated: true)
            }else if indexPath.row == 3
            {
                let t = TaskNotifyViewController()
                self.navigationController?.pushViewController(t, animated: true)
            }
        }else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                let list = ChatListViewController()
                self.navigationController?.pushViewController(list, animated: true)
            }else if indexPath.row == 1
            {
                let contact = ContactViewController()
                self.navigationController?.pushViewController(contact, animated: true)
            }else if indexPath.row == 2
            {
                let group = GroupViewController()
                self.navigationController?.pushViewController(group, animated: true)
            }else if indexPath.row == 3
            {
                let bbs = BBSViewController()
                self.navigationController?.pushViewController(bbs, animated: true)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//MARK: UICollectionViewDataSource
extension TaskChatViewController : UICollectionViewDataSource
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {//广告栏
            return 4
        }else if section == 1
        {
            return 4
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
        cell.nameLabel.font = UIFont.systemFontOfSize(14)
        cell.nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        if indexPath.section == 0 {
            
            let images = ["task_new", "task_my_publish", "task_my", "task_msg", "home_task", "home_link"]
            let names = ["新建任务", "我发布的", "我的任务", "通知通报", "督查督办", "友情链接"]
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            return cell
        } else
        {
            let images = ["chat_list", "chat_contact", "chat_group", "chat_bbs1", "home_task", "home_link"]
            let names = ["会话", "联系人", "讨论组", "他山之石", "督查督办", "友情链接"]
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UICollectionReusableView", forIndexPath: indexPath)
            
            if indexPath.section == 0 {
                let label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 20))
                label.textColor = ThemeManager.current().darkGrayFontColor
                label.font = UIFont.systemFontOfSize(13)
                view.addSubview(label)
                label.text = "督查督办"
                
                let line = GetLineView(CGRect(x: 0, y: 29, width: GetSWidth(), height: 1))
                view.addSubview(line)
            }else{
                let top = UIView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: 10))
                top.backgroundColor = ThemeManager.current().backgroundColor
                view.addSubview(top)
                
                let label = UILabel(frame: CGRect(x: 10, y: 15, width: 100, height: 20))
                label.textColor = ThemeManager.current().darkGrayFontColor
                label.font = UIFont.systemFontOfSize(13)
                view.addSubview(label)
                label.text = "热点话题"
                
                let line = GetLineView(CGRect(x: 0, y: 39, width: GetSWidth(), height: 1))
                view.addSubview(line)
                
            }
            
            return view
        }else{
            return collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionReusableView", forIndexPath: indexPath)
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskChatViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return HomeCell.cellSize()
        }else if indexPath.section == 1
        {
            return HomeCell.cellSize()
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 1 {
            return UIEdgeInsetsMake(5, 10, 5, 10)
        }
        return UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 0
        {
            return CGSizeMake(GetSWidth(), 30)
        }else{
            return CGSizeMake(GetSWidth(), 40)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeZero
    }
}
