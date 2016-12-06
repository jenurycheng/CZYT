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
        layout.scrollDirection = .Vertical

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ThemeManager.current().foregroundColor
        collectionView.registerNib(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        unowned let weakSelf = self
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { 
            weakSelf.getHomeData()
        })
        self.view.addSubview(collectionView)
        
        pageView = CCPageView(frame: CGRectMake(0, 0, GetSWidth(), CCPageView.viewHeight()))
        pageView.delegate = self
        pageView.pageControl.backgroundColor = ThemeManager.current().backgroundColor
        pageView.pageControl.pageIndicatorTintColor = ThemeManager.current().mainColor
        
        self.getHomeData()
        // Do any additional setup after loading the view.
    }
    
    func getHomeData()
    {
        dataSource.getLeaderActivity(true, classify: "省级", success: { (result) in
            self.pageView.loadData()
            self.collectionView.mj_header.endRefreshing()
        }) { (error) in
            
        }
    }
    
    func getUnreadMsg()
    {
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            let a = [RCConversationType.ConversationType_PRIVATE.rawValue as AnyObject, RCConversationType.ConversationType_GROUP.rawValue as AnyObject]
            let count = RCIMClient.sharedRCIMClient().getUnreadCount(a)
            dispatch_async(dispatch_get_main_queue(), { 
                CCPrint("未读消息:\(count)")
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
        if indexPath.section == 1 {
            if indexPath.row == 0
            {
                let ac = LeaderActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 1
            {
                let ac = FileActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 2
            {
                let ac = WorkStatusActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 3
            {
                let ac = ProjectWorkActivityViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 4
            {
                if !UserInfo.sharedInstance.isLogin {
                    let user = UserLoginViewController()
                    user.pushToVC = TaskViewController()
                    let newNav = UINavigationController(rootViewController: user)
                    nav?.presentViewController(newNav, animated: true, completion: nil)
                    return
                }
                let task = TaskViewController()
                nav?.pushViewController(task, animated: true)
            }else if indexPath.row == 5
            {
                if !UserInfo.sharedInstance.isLogin {
                    let user = UserLoginViewController()
                    user.pushToVC = ChatViewController()
                    let newNav = UINavigationController(rootViewController: user)
                    nav?.presentViewController(newNav, animated: true, completion: nil)
                    
                    return
                }
                let ac = ChatViewController()
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 6
            {
                let ac = WebLinkViewController()
                nav?.pushViewController(ac, animated: true)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            pageView.startAnimate()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            pageView.stopAnimate()
        }
        
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController : UICollectionViewDataSource
{
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0 {//广告栏
            return 1
        }else if section == 1   //已安装应用，最多显示4个
        {
            return 7
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
            cell.addSubview(pageView)
            return cell
        } else
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCell
            let images = ["home_leader", "home_file", "home_status", "home_project", "home_task", "home_chat", "home_link"]
            let names = ["时政新闻", "政策文件", "工作动态", "重点项目", "督查督办", "热点话题", "友情链接"]
            cell.iconImageView.image = UIImage(named: images[indexPath.row])
            cell.nameLabel.text = names[indexPath.row]
            return cell
        }
        
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return CGSizeMake(GetSWidth(), CCPageView.viewHeight())
        }else if indexPath.section == 1
        {
            return HomeCell.cellSize()
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 1 {
            return UIEdgeInsetsMake(10, 20, 10, 20)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
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
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeZero
    }
}

extension HomeViewController : UIScrollViewDelegate
{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pageView.stopAnimate()
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageView.startAnimate()
    }
}

//MARK: CCPageViewDelegate
extension HomeViewController : CCPageViewDelegate
{
    func pageCountForPageView(page:CCPageView)->Int
    {
        return dataSource.leaderActivity.count > 3 ? 3 : dataSource.leaderActivity.count
    }
    
    func pageViewForIndex(page:CCPageView, index:Int)->UIView
    {
        let view = UIView(frame: pageView.bounds)
        let imgView = UIImageView(frame: CGRect(x: 10, y: 10, width: page.frame.width-20, height: page.frame.height-25))
        imgView.image = UIImage(named: "test")
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = ThemeManager.current().grayFontColor.CGColor
        view.addSubview(imgView)
        let label = UILabel(frame: CGRect(x: 10, y: page.frame.height-15-30, width: page.frame.width-20, height: 30))
        label.text = dataSource.leaderActivity[index].title
        label.backgroundColor = Helper.parseColor(0x00000077)
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = ThemeManager.current().whiteFontColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        view.addSubview(label)
        imgView.gm_setImageWithUrlString(dataSource.leaderActivity[index].logo_path, title: dataSource.leaderActivity[index].title, completedBlock: nil)
        
        return view
    }
    
    func pageClickedAtIndex(page:CCPageView, index:Int)
    {
        let detail = LeaderActivityDetailViewController(nibName: "LeaderActivityDetailViewController", bundle: nil)
        detail.id = dataSource.leaderActivity[index].id!
        let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
        nav?.pushViewController(detail, animated: true)
    }
}
