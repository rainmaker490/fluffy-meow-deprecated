//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController , MKMapViewDelegate {
    
    let mapViewEvents = SharedInstances.mapInstance
    let trending = SharedInstances.trendingInstance
    let userData = User.sharedInstance
    var annotations = [EventAnnotation]()
    var pinName : String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        getUserEvents()
        
        mapViewEvents.getCurrentLocation()
        mapViewEvents.category = Categories.Favorites
        mapView.delegate = self
        
        let notifications = NSNotificationCenter.defaultCenter()
        notifications.addObserver(self, selector: "receivedCurrentLocationData", name: Notifications.CurrentLocationRecieved, object: nil)
        notifications.addObserver(self, selector: "receivedTopTenTrending", name: Notifications.TopTenReady, object: nil)
        notifications.addObserver(self, selector: "favoritesReceivedPlotOnMap", name: Notifications.FavoritesReceived, object: nil)
        pinName = "DarkBlue.png"
        
    }
    
    func getUserEvents() {
        let query = userData.user!["favoriteEvents"].query()
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if error == nil {
                self.userData.userEvents.removeAll()
                if let favoriteEvents = events as? [Event] {
                    self.userData.userEvents = favoriteEvents
                    let notification = NSNotificationCenter.defaultCenter()
                    notification.postNotificationName(Notifications.FavoritesReceived, object: self)

                }
            }
        }
    }
    
    func favoritesReceivedPlotOnMap(){
        makeAnnotation(userData.userEvents)
        let location = CLLocation(latitude: 37.787359, longitude: -122.408227)
        centerMapOnLocation(location)
        mapView.addAnnotations(annotations)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.regionThatFits(coordinateRegion)
    }
    
    func makeAnnotation(events: [Event]){
        annotations.removeAll()
        for event in events{
            let annotation = EventAnnotation(event: event)
            annotations.append(annotation)
        }
    }
    
    @IBAction func segmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapViewEvents.category = Categories.Favorites
            pinName = "DarkBlue.png"
            break
        case 1:
            mapViewEvents.category = Categories.Sport
            pinName = "LightBlue.png"
            break
        case 2:
            mapViewEvents.category = Categories.Clubs
            pinName = "Yellow.png"
            break
        case 3:
            mapViewEvents.category = Categories.StudyGroups
            pinName = "Green.png"
            break
        case 4:
            mapViewEvents.category = Categories.NightLife
            pinName = "Purple.png"
            break
        case 5:
            mapViewEvents.category = Categories.Concerts
            pinName = "RedPin.png"
            break
        default:
            break
        }
        mapView.reloadInputViews()
        receivedCurrentLocationData()
    }
    
    func receivedCurrentLocationData(){
        annotations.removeAll()
        mapViewEvents.getEvents(mapViewEvents.category!, userGeoPoint: mapViewEvents.currentLocation!, miles: 10, numberOfEvents: -1)
        // if let _ = mapViewEvents.eventsFactory[mapViewEvents.category!]!
        /*for event in mapViewEvents.eventsFactory[mapViewEvents.category!]!{
            let annotation = EventAnnotation(event: event)
            annotations.append(annotation)
        }*/
        // mapViewEvents.getAllEvents(mapViewEvents.currentLocation!, miles: userData.user!["distance"] as! Double)
    }
    
    func receivedTopTenTrending() {
        if mapViewEvents.eventsFactory.count != 0 {
            if mapViewEvents.eventsFactory[mapViewEvents.category!] != nil {
                for event in mapViewEvents.eventsFactory[mapViewEvents.category!]!{
                    let annotation = EventAnnotation(event: event)
                    annotations.append(annotation)
                }
            }
        }
        
        let currentLocation = CLLocation(latitude: (mapViewEvents.currentLocation?.latitude)!, longitude: (mapViewEvents.currentLocation?.longitude)!)
        centerMapOnLocation(currentLocation)
        mapView.addAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                let pinView =  MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                // pinView.calloutOffset = CGPoint(x: -5, y: 5)
                // pinView.pinTintColor = .blueColor()
                // pinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
                pinView.image = UIImage(named: pinName!)
                return pinView
            }
            return view
        }
        return nil
    }
}
