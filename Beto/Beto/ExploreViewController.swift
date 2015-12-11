//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController , MKMapViewDelegate{
    
    let mapViewEvents = SharedInstances.mapInstance
    let trending = SharedInstances.trendingInstance
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        mapViewEvents.getCurrentLocation()
        mapViewEvents.category = "All"
        mapView.delegate = self

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapViewEvents.category = Categories.All
            break
        case 1:
            mapViewEvents.category = Categories.Sport
            break
        case 2:
            mapViewEvents.category = Categories.Clubs
            break
        case 3:
            mapViewEvents.category = Categories.StudyGroups
            break
        case 4:
            mapViewEvents.category = Categories.NightLife
            break
        case 5:
            mapViewEvents.category = Categories.Concerts
            break
        default:
            break
        }
    }
    
    func receivedCurrentLocationData(){
        mapViewEvents.getEvents(mapViewEvents.category!, userGeoPoint: mapViewEvents.currentLocation!, miles: 10, numberOfEvents: -1)
    }
    
    func receivedTopTenTrending() {
        let currentLocation = CLLocation(latitude: (mapViewEvents.currentLocation?.latitude)!, longitude: (mapViewEvents.currentLocation?.longitude)!)
        centerMapOnLocation(currentLocation)
    }
    
}
