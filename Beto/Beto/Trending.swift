//
//  Trending.swift
//  Beto
//
//  Created by Varun D Patel on 12/6/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

protocol CurrentLocationDelegate : class {
    var currentLocation : PFGeoPoint {
        get
    }
}

class Trending : NilLiteralConvertible {
    
    weak var dataSource : CurrentLocationDelegate?
    private var trendingFactory = [Event]()
    var eventsFactory = [String:[Event]]()
    
    func getTrendingEvents(type : String, miles: Double, numberOfEvents: Int, sendNotification: Bool){
        let query = PFQuery(className: "Event")
        if type == Categories.All {
            query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles)
        } else {
            query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles).whereKey("category", containsString: type)
        }
        query.orderByDescending("views")
        query.limit = numberOfEvents
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                var allEventsList = [Event]()
                if let event = objects as? [Event] {
                    allEventsList = event
                }
                self.eventsFactory[type]?.removeAll()
                self.eventsFactory[type] = allEventsList
                if sendNotification {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        let notification = NSNotificationCenter.defaultCenter()
                        notification.postNotificationName(Notifications.TopTenReady, object: self)
                    }
                }
            }
        }
    }
    
    init(){}
    
    required init(nilLiteral: ()) {}
    
}