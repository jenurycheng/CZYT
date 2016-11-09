//
//  WebLinkViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class WebLinkViewController: BasePortraitViewController {

    var tableView:UITableView!
    var dataSource = LeaderActivityDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        self.view.showHud()
        dataSource.getWebLink({ (result) in
            self.view.dismiss()
            self.tableView.reloadData()
            }) { (error) in
            self.view.dismiss()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WebLinkViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.webLinks.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let web = WebViewController()
        web.url = dataSource.webLinks[indexPath.row].href
        web.title = dataSource.webLinks[indexPath.row].title
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: nil)
        cell.imageView?.image = UIImage(named: "star")
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.text = dataSource.webLinks[indexPath.row].title
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
}
