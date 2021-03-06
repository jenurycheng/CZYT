//
//  WorkStatusDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class WorkStatusDetailViewController: BaseDetailViewController {
    var hiddenItem = false
    var id:String = ""
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "动态消息"
        self.loadData()
        if UserInfo.sharedInstance.adviceEnabled() && !hiddenItem{
            let assignItem = UIBarButtonItem(title: "批示", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProjectWorkDetailViewController_New.assignBtnClicked))
            self.navigationItem.rightBarButtonItem = assignItem
        }
        
        // Do any additional setup after loading the view.
    }
    
    func assignBtnClicked()
    {
        if dataSource?.id == nil {
            return
        }
        
        let list = PublishApproveViewController()
        list.id = dataSource?.id
        list.type = "2"
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSourceApi.getWorkStatusActivityDetail(id, success: { (result) in
            self.update(result)
            self.view.dismiss()
        }) { (error) in
            self.view.dismiss()
            NetworkErrorView.show(self.view, data: error, callback: {
                self.loadData()
            })
            
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
