//
//  TabBarViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    var viewControllers:Array<UIViewController>?
    var currentIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        if viewControllers != nil && viewControllers?.count > 0 {
            let first = viewControllers![0]
            self.addChildViewController(first)
            self.view.addSubview(first.view)
            currentIndex = 0
        }
        // Do any additional setup after loading the view.
    }
    
    func showIndex(index:Int)
    {
        if viewControllers != nil && viewControllers?.count > index {
            let vc = viewControllers![index]
            let v = self.childViewControllers.count
            if !self.childViewControllers.contains(vc) {
                self.addChildViewController(vc)
            }
            let current = self.viewControllers![currentIndex!]
            current.view.removeFromSuperview()
            current.removeFromParentViewController()
            self.view.addSubview(vc.view)
            
            currentIndex = index
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
