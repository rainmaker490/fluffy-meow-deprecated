//
//  Trending.swift
//  Beto
//
//  Created by Varun D Patel on 12/6/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

class SharedInstances {
    static let sharedInstance = Trending()
    static let mapInstance = Trending()
}

class Trending {
    
    var currentLocation: PFGeoPoint?
    
    var category : String?
    private var trendingFactory = [Event]()
    var eventsFactory = [String:[Event]]()
    
    func getEvents(category : String, userGeoPoint: PFGeoPoint, miles: Double, numberOfEvents: Int){
        let query = PFQuery(className: "Event")
        
        if(category == "All") {
            query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles)
        } else {
            query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles).whereKey("category", containsString: category)
        }
        
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                var trendingFactory = [Event]()
                var allEventsList = [Event]()
                if let event = objects as? [Event] {
                    allEventsList = event
                    allEventsList.sortInPlace({ $0.views > $1.views })
                    if numberOfEvents < 0 {
                        trendingFactory = allEventsList
                    } else {
                        for var i = 0; i<numberOfEvents && i < allEventsList.count ; i++ {
                            trendingFactory.append(allEventsList[i])
                        }
                    }
                }
                self.eventsFactory[category] = trendingFactory
                
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(Notifications.TopTenReady, object: self)
            }
        })
    }
    
    func getCurrentLocation(){
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                self.currentLocation = geoPoint
                let notifications = NSNotificationCenter.defaultCenter()
                notifications.postNotificationName(Notifications.CurrentLocationRecieved, object: self)
            }
        }
    }
    
    private init(){}
    
}