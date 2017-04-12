//
//  BaseOrientationNavViewController.swift

//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BaseOrientationNavViewController: UINavigationController, UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    var canSideBack:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if responds(to: Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.canSideBack
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        
        return self.viewControllers.last!.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return self.viewControllers.last!.preferredInterfaceOrientationForPresentation
    }
    
    override var shouldAutorotate : Bool {
        return self.viewControllers.last!.shouldAutorotate
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            self.canSideBack = false
        }else{
            self.canSideBack = true
        }
    }
}
