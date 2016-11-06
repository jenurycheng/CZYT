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
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.canSideBack
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return self.viewControllers.last!.supportedInterfaceOrientations()
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return self.viewControllers.last!.preferredInterfaceOrientationForPresentation()
    }
    
    override func shouldAutorotate() -> Bool {
        return self.viewControllers.last!.shouldAutorotate()
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count == 1 {
            self.canSideBack = false
        }else{
            self.canSideBack = true
        }
    }
}
