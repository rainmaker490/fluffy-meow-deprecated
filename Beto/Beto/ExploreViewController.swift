//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ExploreViewController: GetEventsViewController , MKMapViewDelegate{
    
    var annotations = [EventAnnotation]()
    var pinName : String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        category.explore = Categories.Favorites
        mapView.delegate = self
        pinName = "DarkBlue.png"
        getUserEvents()
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
            category.explore = Categories.Favorites
            pinName = "DarkBlue.png"
            break
        case 1:
            category.explore = Categories.Sport
            pinName = "LightBlue.png"
            break
        case 2:
            category.explore = Categories.Clubs
            pinName = "Yellow.png"
            break
        case 3:
            category.explore = Categories.StudyGroups
            pinName = "Green.png"
            break
        case 4:
            category.explore = Categories.NightLife
            pinName = "Purple.png"
            break
        case 5:
            category.explore = Categories.Concerts
            pinName = "RedPin.png"
            break
        default:
            break
        }
        receivedCurrentLocationData()
    }
    
    func receivedCurrentLocationData(){
        annotations.removeAll()
        trending.getTrendingEvents(category.explore!, miles: 10, numberOfEvents: -1, sendNotification: true)
    }
    
    func receivedTopTenTrending() {
        if trending.eventsFactory.count != 0 {
            if trending.eventsFactory[category.explore!] != nil {
                for event in trending.eventsFactory[category.explore!]!{
                    let annotation = EventAnnotation(event: event)
                    annotations.append(annotation)
                }
            }
        }
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
