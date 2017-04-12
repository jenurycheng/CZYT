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
        self.title = "友情链接"
        self.view.backgroundColor = ThemeManager.current().backgroundColor
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.webLinks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let web = WebViewController()
        web.url = dataSource.webLinks[indexPath.row].href
        web.title = dataSource.webLinks[indexPath.row].title
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.imageView?.image = UIImage(named: "link_small")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.text = dataSource.webLinks[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        let line = GetLineView(CGRect(x: 10, y: 49, width: GetSWidth(), height: 1))
        cell.addSubview(line)
        return cell
    }
}
