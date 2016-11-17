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
        self.view.addSubview(collectionView)
        
        pageView = CCPageView(frame: CGRectMake(0, 0, GetSWidth(), CCPageView.viewHeight()))
        pageView.delegate = self
        pageView.pageControl.backgroundColor = ThemeManager.current().backgroundColor
        pageView.pageControl.pageIndicatorTintColor = ThemeManager.current().mainColor
        
        dataSource.getLeaderActivity(true, success: { (result) in
            self.pageView.loadData()
            }) { (error) in
                
        }
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
extension HomeViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 1 {
            if indexPath.row == 0
            {
                let ac = LeaderActivityViewController()
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 1
            {
                let ac = FileActivityViewController()
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 2
            {
                let ac = WorkStatusActivityViewController()
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 3
            {
                let ac = ProjectWorkActivityViewController()
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 4
            {
                let ac = WebLinkViewController()
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(ac, animated: true)
            }else if indexPath.row == 5
            {
                
            }else if indexPath.row == 6
            {
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                if !UserInfo.sharedInstance.isLogin {
                    let user = UserInfoViewController()
                    nav?.pushViewController(user, animated: true)
                    return
                }
                let ac = ChatViewController()
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
            let images = ["user_header_default", "user_header_default", "user_header_default", "user_header_default", "user_header_default", "user_header_default", "user_header_default"]
            let names = ["领导活动", "政策文件", "工作状态", "项目工作", "友情链接", "督查督办", "互动交流"]
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
        return dataSource.leaderActivity.count
    }
    
    func pageViewForIndex(page:CCPageView, index:Int)->UIView
    {
        let view = UIView(frame: pageView.bounds)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: page.frame.width, height: page.frame.height-20))
        imgView.image = UIImage(named: "test")
        view.addSubview(imgView)
        let label = UILabel(frame: CGRect(x: 0, y: page.frame.height-20-30, width: page.frame.width, height: 30))
        label.text = dataSource.leaderActivity[index].title
        label.backgroundColor = Helper.parseColor(0x00000077)
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = ThemeManager.current().whiteFontColor
        view.addSubview(label)
//        let url = dataSource.appHome!.ad![index].image
//        let loadImage = Helper.imageWithLoading(page.frame.size)
//        imgView.gm_setImageWithURL(NetWorkHandle.getImageUrl(url), placeholderImage: loadImage) { (img:UIImage!, err:NSError!, type:SDImageCacheType, url:NSURL!) -> Void in
//            if nil != err {
//                let image = Helper.imageWithString(self.dataSource.appHome!.ad![index].title, size:imgView.frame.size)
//                imgView.image = image
//            }
//        }
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
