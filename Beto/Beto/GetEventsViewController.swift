//
//  GetEventsViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/22/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

class GetEventsViewController: UIViewController, CLLocationManagerDelegate, CurrentLocationDelegate{
    
    let trending = SharedInstances.trendingInstance
    var category = SharedInstances.categoriesInstance
    let userData = User.sharedInstance
    var distance : Double?
    let locationManager = CLLocationManager()
    
    var currentLocation : PFGeoPoint {
        get {
            if let location = locationManager.location {
                return PFGeoPoint(location: location)
            } else {
                let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
                return PFGeoPoint(latitude: sanFrancisco.latitude , longitude: sanFrancisco.longitude)
            }
        }
    }
    
    override func viewDidLoad() {
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        trending.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.locationServicesEnabled()  {
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            let notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName(Notifications.CurrentLocationRecieved, object: self)
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    /*func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("didSelectRowAtIndexPath", sender: indexPath)
    }*/
}
