//
//  TabBarViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TabBarViewController: BasePortraitViewController {

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
    
    func showIndex(_ index:Int)
    {
        if viewControllers != nil && viewControllers?.count > index {
            let vc = viewControllers![index]
            if !self.childViewControllers.contains(vc) {
                self.addChildViewController(vc)
            }
            if currentIndex != nil
            {
                let current = self.viewControllers![currentIndex!]
                current.view.removeFromSuperview()
                current.removeFromParentViewController()
            }
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
