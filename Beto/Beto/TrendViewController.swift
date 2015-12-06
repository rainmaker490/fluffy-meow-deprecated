//
//  TrendViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/2/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trendingSegementedControl: UISegmentedControl!
    
    var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        
        tableView.addSubview(refreshControl)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("MoreViewController") as! TrendingTableViewCell
            return cell
    }
}
