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
    
    let trending = Trending.sharedInstance

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trendingSegementedControl: UISegmentedControl!
    
    var refreshControl: UIRefreshControl!
    
    var topTenTrending = [String]()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        
        tableView.addSubview(refreshControl)
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.trending.currentLocation = geoPoint
                print(geoPoint)
                self.tableView.reloadData()
            }
        }
        
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: 39.05, longitude: -95.78),
            radius: (25*1000*0.62137),
            identifier: "USA"
        )
        
        let address = "1 Infinite Loop, CA, USA"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
        })
        
        
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
        cell.trendingEventTitle.text = String(trending.currentLocation?.latitude)
        return cell
    }
}
