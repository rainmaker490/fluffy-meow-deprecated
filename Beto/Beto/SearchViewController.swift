//
//  SearchViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/10/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController /*, UITableViewDelegate, UITableViewDataSource , EventDetails*/{
    
    let search = SharedInstances.searchInstance
    var currentLocation : PFGeoPoint?
    let userData = User.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.EventFactoryReady, object: nil)
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        // tableView.dataSource = self
        // tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func receivedCurrentLocationData(){
        // search.getAllEvents(userData.user!["distance"] as! Double, sendNotification: true)
    }
    
    func receivedTopTenTrending() {
        tableView.reloadData()
    }

    func refresh(refreshControl: UIRefreshControl) {
        // search.getAllEvents(userData.user!["distance"] as! Double, sendNotification: true)
        refreshControl.endRefreshing()
    }
    
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return search.numberOfSections
    }*/
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.numberOfEventsInSection(section)
    }*/
    
    /*func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllEventTitles") as! SearchTableViewCell
        cell.allEventTitle.text = search.eventNameAtIndexPath(indexPath).title
        return cell
    }*/
    
    /*func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return search.titleForSection(section)
    }*/
    
    /*var currentEvent : Event {
        get {
            let indexPath = tableView.indexPathForSelectedRow!
            return search.eventsFactory[search.getKey(indexPath.section)]![indexPath.row]
        }
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "SearchViewControllerGetInfo":
            let infoViewController = segue.destinationViewController as! InfoViewController
            // infoViewController.dataSource = self
            infoViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
}
