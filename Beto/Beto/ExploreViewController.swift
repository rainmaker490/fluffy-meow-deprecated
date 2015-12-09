//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Mapbox

class ExploreViewController: UIViewController, MGLMapViewDelegate {
    
    let mapViewEvents = SharedInstances.mapInstance
    let trending = SharedInstances.sharedInstance
    
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        mapViewEvents.getCurrentLocation()
        mapView.styleURL = MGLStyle.emeraldStyleURL()
        // mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: trending.currentLocation!.latitude, longitude: trending.currentLocation!.longitude), zoomLevel: 15, animated: false)
        mapViewEvents.category = "All"
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: trending.currentLocation!.latitude, longitude: trending.currentLocation!.longitude)
        point.title = "Hello world!"
        point.subtitle = "Welcome to My Current Location."
        
        
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        mapViewEvents.getEvents(mapViewEvents.category!, userGeoPoint: trending.currentLocation!, miles: 10, numberOfEvents: -1 )
        
        mapView.addAnnotation(point)
        mapView.delegate = self
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
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func receivedTopTenTrending() {
        var points = [MGLPointAnnotation]()
        for event in mapViewEvents.eventsFactory[mapViewEvents.category!]! {
            let eventCoordinate = event.location
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: eventCoordinate.latitude, longitude: eventCoordinate.longitude)
            point.title = event.title
            points.append(point)
        }
        mapView.addAnnotations(points)
        mapView.reloadInputViews()
    }
    
}
