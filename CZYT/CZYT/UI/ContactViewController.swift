//
//  ContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ContactViewController: BasePortraitViewController {

    var dataSource = ChatDataSource()
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.getDepartmentList({ (result) in
            
            }) { (error) in
                
        }
        dataSource.getContactList("3", success: { (result) in
            
            }) { (error) in
                
        }
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.setTitle("h", forState: .Normal)
        btn.backgroundColor = ThemeManager.current().mainColor
        btn.addTarget(self, action: #selector(ContactViewController.btnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
        
        // Do any additional setup after loading the view.
    }
    
    func btnClicked()
    {
        let chat = RCConversationViewController()
        chat.conversationType = RCConversationType.ConversationType_PRIVATE
        chat.targetId = "3"
        chat.title = "h"
        self.navigationController?.pushViewController(chat, animated: true)
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
