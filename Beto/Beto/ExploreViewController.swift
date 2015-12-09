//
//  ExploreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController {
    
    let mapViewEvents = SharedInstances.mapInstance
    let trending = SharedInstances.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        mapViewEvents.getCurrentLocation()
        
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
        
    }
    
}
