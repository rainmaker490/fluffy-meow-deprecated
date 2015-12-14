//
//  EventAnnotation.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import MapKit
import Parse


class EventAnnotation: NSObject, MKAnnotation {
    
    let event: Event
    let title: String?
    let coordinateParse: PFGeoPoint
    let coordinate: CLLocationCoordinate2D
    
    init(event: Event) {
        self.event = event
        self.title = event.title
        self.coordinateParse = event.location
        self.coordinate = CLLocationCoordinate2D(latitude: coordinateParse.latitude, longitude: coordinateParse.longitude)
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
