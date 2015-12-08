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

class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let trending = Trending.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trendingSegementedControl: UISegmentedControl!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        trending.getCurrentLocation()
        
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        spinner.startAnimating()
        /*let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: 39.05, longitude: -95.78),
            radius: (25*1000*0.62137),
            identifier: "USA"
        )
        
        let address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
        })*/
        
    }
    
    func receivedCurrentLocationData(){
        trending.getTopTen("Sport", userGeoPoint: self.trending.currentLocation!, miles: 10)
    }
    
    func receivedTopTenTrending() {
        spinner.stopAnimating()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        spinner.startAnimating()
        trending.getTopTen("jjj", userGeoPoint: self.trending.currentLocation!, miles: 10)
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trending.topTenTrendingEventsNearYou.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MoreViewController") as! TrendingTableViewCell
        cell.trendingEventTitle.text = String(trending.topTenTrendingEventsNearYou[indexPath.row].title)
        return cell
    }
}
