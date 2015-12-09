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
    
    let trending = Trending.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        
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
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        trending.category = "All"
    }
    
    @IBAction func segmentedControlSelected(sender: UISegmentedControl) {
        spinner.startAnimating()
        switch sender.selectedSegmentIndex {
        case 0:
            trending.category = "All"
           break
        case 1:
            trending.category = "Sport"
            break
        case 2:
            trending.category = "Clubs"
            break
        case 3:
            trending.category = "Study Groups"
           break
        case 4:
            trending.category = "Night Life"
           break
        case 5:
            trending.category = "Concerts"
           break
        default:
            break
        }
        
        if let _ = trending.topTenTrendingEventsNearYou[trending.category!] {
            receivedTopTenTrending()
        } else {
            trending.getTopTen(trending.category!, userGeoPoint: trending.currentLocation!, miles: 10)
        }
    }
    
    func receivedCurrentLocationData(){
        spinner.startAnimating()
        trending.getTopTen(trending.category!, userGeoPoint: trending.currentLocation! , miles: 10)
    }
    
    func receivedTopTenTrending() {
        tableView.reloadData()
        spinner.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        trending.getTopTen(trending.category!, userGeoPoint: trending.currentLocation!, miles: 10)
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let _ =  trending.topTenTrendingEventsNearYou[trending.category!] {
            numberOfSections = trending.topTenTrendingEventsNearYou[trending.category!]!.count
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoreViewController") as! TrendingTableViewCell
        cell.trendingEventTitle.text = String(trending.topTenTrendingEventsNearYou[trending.category!]![indexPath.row].title)
        return cell
    }
    
    var currentEvent : Event {
        get {
            return trending.topTenTrendingEventsNearYou[trending.category!]![tableView.indexPathForSelectedRow!.row]
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
