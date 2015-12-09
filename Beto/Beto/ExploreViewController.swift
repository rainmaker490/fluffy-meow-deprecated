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
    
    let trending = Trending.sharedInstance
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        mapView.styleURL = NSURL(string: "asset://styles/emerald-v8.json")
        
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: trending.currentLocation!.latitude,
            longitude: trending.currentLocation!.longitude),
            zoomLevel: 15, animated: false)
        
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: trending.currentLocation!.latitude, longitude: trending.currentLocation!.longitude)
        point.title = "Hello world!"
        point.subtitle = "Welcome to My Current Location."
        
        mapView.addAnnotation(point)
        
        mapView.delegate = self
    }

    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

}
