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
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear//ThemeManager.current().foregroundColor
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        self.view.addSubview(collectionView)
        UserInfo.sharedInstance.addObserver(self, forKeyPath: "unreadMsg", options: .new, context: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit{
        UserInfo.sharedInstance.removeObserver(self, forKeyPath: "unreadMsg")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "unreadMsg" {
            let index = IndexPath(item: 1, section: 1)
            collectionView.reloadItems(at: [index])
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            var row = indexPath.row
            if !UserInfo.sharedInstance.publishEnabled() {
                row = row + 2
            }
            if row == 0
            {
                let new = PublishTaskViewController(nibName: "PublishTaskViewController", bundle: nil)
                self.navigationController?.pushViewController(new, animated: true)
            }else if row == 1
            {
                let my = MyPublishTaskViewControllerTemp()
                self.navigationController?.pushViewController(my, animated: true)
            }else if row == 2
            {
                let my = MyTaskViewControllerTemp()
                self.navigationController?.pushViewController(my, animated: true)
            }else if row == 3
            {
                let t = TaskNotifyViewController()
                self.navigationController?.pushViewController(t, animated: true)
            }else if row == 4
            {
                
            }
        }else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                let contact = ContactViewController()
                self.navigationController?.pushViewController(contact, animated: true)
            }else if indexPath.row == 1
            {
                let list = ChatListViewController()
                self.navigationController?.pushViewController(list, animated: true)
                if UserInfo.sharedInstance.unreadMsg != 0 {
                    UserInfo.sharedInstance.unreadMsg = 0
                }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

//MARK: UICollectionViewDataSource
extension TaskChatViewController : UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {
            if !UserInfo.sharedInstance.publishEnabled()
            {
                return 2
            }
            return 4
        }else if section == 1
        {
            return 4
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
        cell.nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        if indexPath.section == 0 {
            
            var images = ["task_new", "task_my_publish", "task_my", "task_msg", "home_task", "home_link"]
            var names = ["新建任务", "我的发布", "我的任务", "通知通报", "批示列表", "友情链接"]
            if !UserInfo.sharedInstance.publishEnabled() {
                images = ["task_my", "task_msg", "home_task", "home_link"]
                names = ["我的任务", "通知通报", "批示列表", "友情链接"]
            }
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            cell.numLabel.isHidden = true
            return cell
        } else
        {
            if indexPath.row == 1 && UserInfo.sharedInstance.unreadMsg != 0{
                cell.numLabel.text = "\(UserInfo.sharedInstance.unreadMsg)"
                cell.numLabel.isHidden = false
            }else{
                cell.numLabel.isHidden = true
            }
            let images = ["chat_contact", "chat_list", "chat_group", "chat_bbs1", "home_task", "home_link"]
            let names = ["联系人", "会话", "讨论组", "建言献策", "督查督办", "友情链接"]
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
            
            if indexPath.section == 0 {
                let label = UILabel(frame: CGRect(x: 10, y: 5, width: 100, height: 20))
                label.textColor = ThemeManager.current().darkGrayFontColor
                label.font = UIFont.systemFont(ofSize: 13)
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
                label.font = UIFont.systemFont(ofSize: 13)
                view.addSubview(label)
                label.text = "互动交流"
                
                let line = GetLineView(CGRect(x: 0, y: 39, width: GetSWidth(), height: 1))
                view.addSubview(line)
            }
            
            return view
        }else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskChatViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return HomeCell.cellSize()
        }else if indexPath.section == 1
        {
            return HomeCell.cellSize()
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section == 1 {
            return UIEdgeInsetsMake(5, 10, 5, 10)
        }
        return UIEdgeInsetsMake(5, 10, 5, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 0
        {
            return CGSize(width: GetSWidth(), height: 30)
        }else{
            return CGSize(width: GetSWidth(), height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize.zero
    }
}
