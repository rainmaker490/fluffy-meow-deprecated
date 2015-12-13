//
//  FavoriteViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/13/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , EventDetails{
    
    @IBOutlet weak var tableView: UITableView!
    let search = SharedInstances.trendingInstance
    let userData = User.sharedInstance
    
    var refreshControl: UIRefreshControl!
    var userEvents = [Event]()
    
    override func viewDidLoad() {
        userEvents = User.sharedInstance.userEvents
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    var currentEvent : Event {
        get {
            return userData.userEvents[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        userEvents = User.sharedInstance.userEvents
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        userEvents = User.sharedInstance.userEvents
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteEvents") as! SearchTableViewCell
        cell.allEventTitle.text = userEvents[indexPath.row].title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "FavoriteGetInfo":
            let infoViewController = segue.destinationViewController as! InfoViewController
            infoViewController.dataSource = self
            infoViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }

}
