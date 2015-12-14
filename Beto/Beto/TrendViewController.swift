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

class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , EventDetails{
    
    let trending = SharedInstances.trendingInstance
    let userData = User.sharedInstance
    var distance : Double?
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        trending.category = "All"
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        trending.getCurrentLocation()
        /*let region = CLCircularRegion(
        center: CLLocationCoordinate2D(latitude: 39.05, longitude: -95.78),
        radius: (25*1000*0.62137),
        identifier: "USA"
        )
        
        let address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
        
        })*/
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
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func segmentedControlSelected(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            trending.category = Categories.All
            break
        case 1:
            trending.category = Categories.Sport
            break
        case 2:
            trending.category = Categories.Clubs
            break
        case 3:
            trending.category = Categories.StudyGroups
            break
        case 4:
            trending.category = Categories.NightLife
            break
        case 5:
            trending.category = Categories.Concerts
            break
        default:
            break
        }
        trending.getEvents(trending.category!, userGeoPoint: trending.currentLocation!, miles: userData.user!["distance"] as! Double, numberOfEvents: 10)
    }
    
    func receivedCurrentLocationData(){
        trending.getEvents(trending.category!, userGeoPoint: trending.currentLocation!, miles: userData.user!["distance"] as! Double, numberOfEvents: 10)
    }
    
    func receivedTopTenTrending() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        trending.getCurrentLocation()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let _ =  trending.eventsFactory[trending.category!] {
            numberOfSections = trending.eventsFactory[trending.category!]!.count
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTitles") as! TrendingTableViewCell
        cell.trendingEventTitle.text = String(trending.eventsFactory[trending.category!]![indexPath.row].title)
        return cell
    }
    
    var currentEvent : Event {
        get {
            return trending.eventsFactory[trending.category!]![tableView.indexPathForSelectedRow!.row]
        }
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("didSelectRowAtIndexPath", sender: indexPath)
    }*/
    
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
