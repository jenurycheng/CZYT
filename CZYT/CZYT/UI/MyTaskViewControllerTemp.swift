//
//  MyTaskViewControllerTemp.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class MyTaskViewControllerTemp: TabBarViewController {
    
    var tabTitleView:CCTabTitleView!
    var myTaskVC : MyTaskViewController?
    var myApproveVC : MyApproveViewController?
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
//        self.navigationItem.titleView = tabTitleView
        
        myTaskVC = MyTaskViewController()
        myApproveVC = MyApproveViewController()
        
        self.viewControllers = [myTaskVC!, myApproveVC!]
        
        seg = UISegmentedControl(frame: CGRect(x: 0, y: 8, width: 160, height: 26))
        seg?.insertSegment(withTitle: "我的任务", at: 0, animated: false)
        seg?.insertSegment(withTitle: "我的批示", at: 1, animated: false)
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

extension MyTaskViewControllerTemp : CCTabTitleViewDelegate
{
    func titleCount() -> Int! {
        return 2
    }
    
    func titleForPosition(_ pos: NSInteger) -> String! {
        return  ["我的任务", "我的批示"][pos]
    }
    
    func titleViewIndexDidSelected(_ titleView: CCTabTitleView, index: Int) {
        self.showIndex(index)
        tabTitleView.updateLine(CGFloat(index)/2)
        
        self.title = ["我的任务", "我的批示"][index]
    }
}
