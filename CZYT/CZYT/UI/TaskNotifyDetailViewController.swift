//
//  TaskNotifyDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/22.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class TaskNotifyDetailViewController: BaseDetailViewController {

    var id:String = ""
    var dataSourceApi = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSourceApi.getTaskNotifyDetail(id, success: { (result) in
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
