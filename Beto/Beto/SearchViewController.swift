//
//  SearchViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/10/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: GetEventsViewController, UITableViewDelegate, UITableViewDataSource, EventDetails{
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        notifications.addObserver(self, selector: #selector(SearchViewController.receivedEvents), name: Notifications.EventFactoryReady, object: nil)
        allEventsInstance.getAllEvents(userData.user!["distance"] as! Double, sendNotification: true)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func receivedEvents() {
        tableView.reloadData()
    }

    func refresh(refreshControl: UIRefreshControl) {
        allEventsInstance.getAllEvents(userData.user!["distance"] as! Double, sendNotification: true)
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return allEventsInstance.numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEventsInstance.numberOfEventsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllEventTitles") as! SearchTableViewCell
        cell.allEventTitle.text = allEventsInstance.eventNameAtIndexPath(indexPath).title
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allEventsInstance.titleForSection(section)
    }
    
    var currentEvent : Event {
        get {
            let indexPath = tableView.indexPathForSelectedRow!
            return allEventsInstance.eventsFactory[allEventsInstance.getKey(indexPath.section)]![indexPath.row]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "SearchViewControllerGetInfo":
            let infoViewController = segue.destinationViewController as! InfoViewController
            infoViewController.dataSource = self
            infoViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
}
