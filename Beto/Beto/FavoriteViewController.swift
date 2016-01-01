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
    
    let userData = User.sharedInstance
    var refreshControl: UIRefreshControl!
    let notifications = NSNotificationCenter.defaultCenter()
    
    override func viewDidLoad() {
        notifications.addObserver(self, selector: "receivedFavorites", name: Notifications.FavoritesReceived, object: nil)
        userData.getFavorites()
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
    
    func receivedFavorites(){
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        userData.getFavorites()
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.userEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteEvents") as! SearchTableViewCell
        cell.allEventTitle.text = userData.userEvents[indexPath.row].title
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
