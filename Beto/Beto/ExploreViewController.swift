//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{
    
    let mapViewEvents = SharedInstances.mapInstance
    let trending = SharedInstances.sharedInstance
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        mapViewEvents.getCurrentLocation()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapViewEvents.category = "All"
            break
        case 1:
            mapViewEvents.category = "Sport"
            break
        case 2:
            mapViewEvents.category = "Clubs"
            break
        case 3:
            mapViewEvents.category = "Study Groups"
            break
        case 4:
            mapViewEvents.category = "Night Life"
            break
        case 5:
            mapViewEvents.category = "Concerts"
            break
        default:
            break
        }
    }
    
    func receivedTopTenTrending() {
        let currentLocation = CLLocation(latitude: (mapViewEvents.currentLocation?.latitude)!, longitude: (mapViewEvents.currentLocation?.longitude)!)
        centerMapOnLocation(currentLocation)
    }
    
}
