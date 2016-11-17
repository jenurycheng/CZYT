//
//  GroupConversationViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class GroupConversationViewController: RCConversationViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
    
        if conversationType == RCConversationType.ConversationType_GROUP
        {
            let groupItem = UIBarButtonItem(barButtonSystemItem: .Organize, target: self, action: #selector(GroupConversationViewController.groupItemClicked))
            self.navigationItem.rightBarButtonItem = groupItem
        }
        // Do any additional setup after loading the view.
    }
    
    func groupItemClicked()
    {
        let detail = GroupDetailViewController()
        detail.groupId = self.targetId
        self.navigationController?.pushViewController(detail, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
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
