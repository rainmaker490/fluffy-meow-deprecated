//
//  TrendViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/2/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse
import MapKit

class TrendViewController: GetEventsViewController, UITableViewDelegate, UITableViewDataSource , EventDetails {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notifications.addObserver(self, selector: #selector(TrendViewController.receivedEvents), name: Notifications.TopTenReady, object: nil)
        category.trending = Categories.All
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            self.trending.getTrendingEvents(Categories.All, miles: self.userData.user!["distance"] as! Double, numberOfEvents: 10, sendNotification: true)
        }
        // #TODO:
        // REMOVE AND REFACTOR !!!
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: " ↓ Refresh ↓ ")
        refreshControl.addTarget(self, action: #selector(TrendViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @IBAction func segmentedControlSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            category.trending! = Categories.All
            break
        case 1:
            category.trending! = Categories.Sport
            break
        case 2:
            category.trending! = Categories.Clubs
            break
        case 3:
            category.trending! = Categories.StudyGroups
            break
        case 4:
            category.trending! = Categories.NightLife
            break
        case 5:
            category.trending! = Categories.Concerts
            break
        default:
            break
        }
        
        if let _ = trending.eventsFactory[category.trending!] {
            tableView.reloadData()
        } else {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
                self.trending.getTrendingEvents(self.category.trending!, miles: self.userData.user!["distance"] as! Double, numberOfEvents: 10, sendNotification: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category.trending!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventHeader") as! TrendingTableViewHeaderCell
        cell.sectionHeader.text = category.trending!
        cell.sectionHeaderImage.contentMode = .ScaleAspectFit
        cell.sectionHeaderImage.image = UIImage(named: category.trending!.stringByReplacingOccurrencesOfString(" ", withString: "")+".png")
        return cell
    }
    
    func receivedEvents(){
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        let sendNotification : Bool = category.trending! == Categories.All ? true : false
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            self.trending.getTrendingEvents(Categories.All, miles: self.userData.user!["distance"] as! Double, numberOfEvents: 10, sendNotification: sendNotification)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let trendingEvents =  trending.eventsFactory[category.trending!] {
            numberOfSections = trendingEvents.count
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTitles") as! TrendingTableViewCell
        cell.trendingEventTitle.text = String(trending.eventsFactory[category.trending!]![indexPath.row].title)
        return cell
    }
    
    var currentEvent : Event {
        get {
            return trending.eventsFactory[category.trending!]![tableView.indexPathForSelectedRow!.row]
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "InfoSegue":
            let infoViewController = segue.destinationViewController as! InfoViewController
            infoViewController.dataSource = self
            infoViewController.completionBlock = { () in self.dismissViewControllerAnimated(true, completion: nil)}
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
}
