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
        category.trending = Categories.All
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedAllEvents", name: Notifications.EventFactoryReady, object: nil)
        trending.getAllEvents(userData.user!["distance"] as! Double)
        // #TODO:
        // REMOVE AND REFACTOR !!!
        let query = userData.user!["favoriteEvents"].query()
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if error == nil {
                self.userData.userEvents.removeAll()
                if let  event  = events as? [Event] {
                    self.userData.userEvents = event
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: " ↓ Refresh ↓ ")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
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
        trending.getEvents(category.trending!, miles: userData.user!["distance"] as! Double)
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
    
    func receivedAllEvents() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        trending.getAllEvents(userData.user!["distance"] as! Double)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let _ =  trending.eventsFactory[category.trending!] {
            let count = trending.eventsFactory[category.trending!]!.count
            numberOfSections = count > 10 ? 10 : count
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
