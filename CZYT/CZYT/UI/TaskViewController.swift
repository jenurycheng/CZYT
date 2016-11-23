//
//  TaskViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/20.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskViewController: TabBarViewController {

    var dataSource = TaskDataSource()
    
    var tabTitleView:CCTabTitleView!
    var myTaskVC : MyTaskViewController?
    var publicshTaskVC : MyPublishTaskViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的任务"
        // Do any additional setup after loading the view.
        backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
        
        tabTitleView = CCTabTitleView(frame: CGRect(x: 40, y: 0, width: GetSWidth()-120, height: 44))
        tabTitleView.spacingLineHidden = true
        tabTitleView.font = UIFont.systemFontOfSize(Helper.scale(60))
        tabTitleView.selectTextColor = ThemeManager.current().whiteFontColor
        tabTitleView.delegate = self
        self.navigationItem.titleView = tabTitleView
        
        myTaskVC = MyTaskViewController()
        publicshTaskVC = MyPublishTaskViewController()
        
        self.viewControllers = [myTaskVC!, publicshTaskVC!]
        
        self.showIndex(0)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TaskViewController.addBtnClicked))
        self.navigationItem.rightBarButtonItem = addItem
        // Do any additional setup after loading the view.
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

extension TaskViewController : CCTabTitleViewDelegate
{
    func titleCount() -> Int! {
        return 2
    }
    
    func titleForPosition(pos: NSInteger) -> String! {
        return  ["我的任务", "我发布的"][pos]
    }
    
    func titleViewIndexDidSelected(titleView: CCTabTitleView, index: Int) {
        self.showIndex(index)
        tabTitleView.updateLine(CGFloat(index)/2)
        
        self.title = ["我的任务", "我发布的"][index]
    }
}
