//
//  HomeViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class HomeViewController: BasePortraitViewController {

    var collectionView:UICollectionView!
    var pageView:CCPageView!
    var dataSource = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let imageView = UIImageView(frame: CGRect(x: 0, y: CCPageView.viewHeight(), width: GetSWidth(), height: GetSHeight()-64-CCPageView.viewHeight()))
        imageView.image = UIImage(named: "home_bg")
        self.view.addSubview(imageView)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear//ThemeManager.current().foregroundColor
        collectionView.register(UINib(nibName: "HomeCell2", bundle: nil), forCellWithReuseIdentifier: "HomeCell2")
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        unowned let weakSelf = self
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf.getHomeData()
        })
        self.view.addSubview(collectionView)
        
        pageView = CCPageView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: CCPageView.viewHeight()))
        pageView.delegate = self
        pageView.pageControl.backgroundColor = ThemeManager.current().backgroundColor
        self.getHomeData()

        UserInfo.sharedInstance.addObserver(self, forKeyPath: "unreadMsg", options: .new, context: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.getUnreadMsg), name: NSNotification.Name.RCKitDispatchMessage, object: nil)
        // Do any additional setup after loading the view.
    }
    
    deinit{
        UserInfo.sharedInstance.removeObserver(self, forKeyPath: "unreadMsg")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.RCKitDispatchMessage, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "unreadMsg" {
            let index = IndexPath(item: 4, section: 1)
            collectionView.reloadItems(at: [index])
        }
    }
    
    func getHomeData()
    {
        dataSource.pageSize = 5
        dataSource.getHomeActivity({ (result) in
            self.pageView.loadData()
            self.collectionView.mj_header.endRefreshing()
            }) { (error) in
                
        }
    }
    
    func getUnreadMsg()
    {
        DispatchQueue.global().async {
            let a = [RCConversationType.ConversationType_PRIVATE.rawValue as AnyObject, RCConversationType.ConversationType_GROUP.rawValue as AnyObject]
            let count = RCIMClient.shared().getUnreadCount(a)
            DispatchQueue.main.async(execute: { 
                CCPrint("未读消息:\(count)")
                UserInfo.sharedInstance.unreadMsg = Int(count)
                let path = IndexPath(item: 4, section: 1)
                self.collectionView.reloadItems(at: [path])
            })
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
extension HomeViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        if indexPath.section == 1 {
            if indexPath.row == 0
            {
                let ac = LeaderActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 1
            {
                let ac = WorkStatusActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }
            else if indexPath.row == 2
            {
                let ac = ProjectWorkActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 3
            {
                let ac = FileActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 4
            {
                if !UserInfo.sharedInstance.isLogin {
                    let user = UserLoginViewController()
                    user.pushToVC = TaskViewController()
                    let newNav = UINavigationController(rootViewController: user)
                    nav?.present(newNav, animated: true, completion: nil)
                    return
                }
                let task = TaskChatViewController()
                nav?.pushViewController(task, animated: true)
            }else if indexPath.row == 5
            {
                let ac = WebLinkViewController()
                nav?.pushViewController(ac, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            pageView.startAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            pageView.stopAnimate()
        }
        
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {//广告栏
            return 1
        }else if section == 1
        {
            return 6
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.addSubview(pageView)
            return cell
        } else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell2", for: indexPath) as! HomeCell2
            let images = ["home_leader", "home_status", "home_project", "home_file", "home_task", "home_link"]
            let names = ["时政新闻", "动态消息", "重点项目", "政策文件", "督办交流", "友情链接"]
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            if indexPath.row == 4 && UserInfo.sharedInstance.unreadMsg != 0{
                cell.numLabel.text = "\(UserInfo.sharedInstance.unreadMsg)"
                cell.numLabel.isHidden = false
            }else{
                cell.numLabel.isHidden = true
            }
            return cell
        }
        
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return CGSize(width: GetSWidth(), height: CCPageView.viewHeight())
        }else if indexPath.section == 1
        {
            return HomeCell2.cellSize()
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section == 1 {
            return UIEdgeInsetsMake(30, 10, 10, 10)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 20
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
        return CGSize.zero
    }
}

extension HomeViewController : UIScrollViewDelegate
{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pageView.stopAnimate()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageView.startAnimate()
    }
}

//MARK: CCPageViewDelegate
extension HomeViewController : CCPageViewDelegate
{
    func pageCountForPageView(_ page:CCPageView)->Int
    {
        return dataSource.homeActivity.count > 5 ? 5 : dataSource.homeActivity.count
    }
    
    func pageViewForIndex(_ page:CCPageView, index:Int)->UIView
    {
        let view = UIView(frame: pageView.bounds)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height-15))
        imgView.image = UIImage(named: "test")
        imgView.layer.borderColor = ThemeManager.current().grayFontColor.cgColor
        view.addSubview(imgView)
        
        let labelView = UIView(frame: CGRect(x: 0, y: page.frame.height-15-30, width: page.frame.width, height: 30))
        labelView.backgroundColor = Helper.parseColor(0x00000077)
        view.addSubview(labelView)
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: page.frame.width-20, height: 30))
        label.text = dataSource.homeActivity[index].title
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = ThemeManager.current().whiteFontColor
        labelView.addSubview(label)
        imgView.gm_setImageWithUrlString(dataSource.homeActivity[index].logo_path, title: dataSource.homeActivity[index].title, completedBlock: nil)
        
        return view
    }
    
    func pageClickedAtIndex(_ page:CCPageView, index:Int)
    {
        let detail = TimeNewsDetailViewController()
        let array = dataSource.homeActivity
        let id = array[index].id
        detail.id = id
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        nav?.pushViewController(detail, animated: true)
    }
}
