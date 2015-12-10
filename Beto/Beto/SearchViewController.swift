//
//  SearchViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/10/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let trending = SharedInstances.sharedInstance
    let search = SharedInstances.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        search.getCurrentLocation()
        search.category = "All"

        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    func receivedCurrentLocationData(){
        // spinner.startAnimating()
        trending.getEvents(trending.category!, userGeoPoint: trending.currentLocation!, miles: 10, numberOfEvents: 10)
    }
    
    func receivedTopTenTrending() {
        tableView.reloadData()
        // spinner.stopAnimating()
    }

    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        trending.getEvents(trending.category!, userGeoPoint: trending.currentLocation!, miles: 10, numberOfEvents: -1)
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 0
        if search.eventsFactory.keys.count > 0{
            numberOfSections = search.eventsFactory.keys.count
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let _ =  search.eventsFactory[trending.category!] {
            numberOfSections = search.eventsFactory[trending.category!]!.count
        }
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventTitles") as! TrendingTableViewCell
        cell.trendingEventTitle.text = String(search.eventsFactory[search.category!]![indexPath.row].title)
        return cell
    }
}
