//
//  SearchViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/10/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    let search = SharedInstances.searchInstance
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.EventFactoryReady, object: nil)
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        search.getCurrentLocation()

        tableView.dataSource = self
        tableView.delegate = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func receivedCurrentLocationData(){
        search.getAllEvents(search.currentLocation!, miles: 10)
    }
    
    func receivedTopTenTrending() {
        tableView.reloadData()
    }

    func refresh(refreshControl: UIRefreshControl) {
        search.getAllEvents(search.currentLocation!, miles: 10)
        refreshControl.endRefreshing()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return search.numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search.numberOfEventsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AllEventTitles") as! SearchTableViewCell
        cell.allEventTitle.text = search.eventNameAtIndexPath(indexPath).title
        return cell
    }
}
