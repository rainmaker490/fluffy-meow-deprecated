//
//  CreateEventsForm.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import MapKit

struct EventsForm {
    var title: String?
    var startDate: NSDate?
    var endDate: NSDate?
    var location: CLLocationCoordinate2D?
    var type: String?
    var url: String?
    var description: String?
    var locationString: String?
    var image: UIImage?
}