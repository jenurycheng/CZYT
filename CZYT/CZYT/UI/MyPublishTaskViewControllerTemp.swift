//
//  MyPublishTaskViewControllerTemp.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MyPublishTaskViewControllerTemp: TabBarViewController {
    
    var tabTitleView:CCTabTitleView!
    var publishApproveVC : MyPublishApproveViewController?
    var publishTaskVC : MyPublishTaskViewController?
    var seg:UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的任务"
        // Do any additional setup after loading the view.
        backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
        
        tabTitleView = CCTabTitleView(frame: CGRect(x: 40, y: 0, width: GetSWidth()-120, height: 44))
        tabTitleView.spacingLineHidden = true
        tabTitleView.font = UIFont.systemFont(ofSize: Helper.scale(60))
        tabTitleView.selectTextColor = ThemeManager.current().whiteFontColor
        tabTitleView.delegate = self
        self.navigationItem.titleView = tabTitleView
        
        publishApproveVC = MyPublishApproveViewController()
        publishTaskVC = MyPublishTaskViewController()
        
        self.viewControllers = [publishTaskVC!, publishApproveVC!]
        
        self.showIndex(0)
        
        seg = UISegmentedControl(frame: CGRect(x: 0, y: 8, width: 160, height: 26))
        seg?.insertSegment(withTitle: "我发布的", at: 0, animated: false)
        seg?.insertSegment(withTitle: "我批示的", at: 1, animated: false)
        seg?.selectedSegmentIndex = 0
        seg?.addTarget(self, action: #selector(MyTaskViewControllerTemp.valueChanged), for: .valueChanged)
        self.navigationItem.titleView = seg
        self.showIndex(0)
    }
    
    func valueChanged()
    {
        let index = seg?.selectedSegmentIndex
        self.showIndex(index!)
    }
    
    func addBtnClicked()
    {
        let add = PublishTaskViewController(nibName: "PublishTaskViewController", bundle: nil)
        self.navigationController?.pushViewController(add, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyPublishTaskViewControllerTemp : CCTabTitleViewDelegate
{
    func titleCount() -> Int! {
        return 2
    }
    
    func titleForPosition(_ pos: NSInteger) -> String! {
        return  ["我发布的", "我批示的"][pos]
    }
    
    func titleViewIndexDidSelected(_ titleView: CCTabTitleView, index: Int) {
        self.showIndex(index)
        tabTitleView.updateLine(CGFloat(index)/2)
        
        self.title = ["我发布的", "我批示的"][index]
    }
}
