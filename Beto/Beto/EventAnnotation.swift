//
//  EventAnnotation.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import MapKit


class EventAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let lat: CLLocationDegrees
    let long: CLLocationDegrees
    let eventTitle: String?
    
    init(coordinate: CLLocationCoordinate2D, eventTitle: String) {
        self.coordinate = coordinate
        self.eventTitle = eventTitle
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
        super.init()
    }
    
    func mapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = eventTitle
        return mapItem
    }
}
