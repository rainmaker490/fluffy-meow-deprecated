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
    static let trendingInstance = Trending()
    static let mapInstance = Trending()
    static let searchInstance = Trending()
}

class Trending {
    
    var currentLocation: PFGeoPoint?
    
    var category : String?
    private var trendingFactory = [Event]()
    var eventsFactory = [String:[Event]]()
    private var keys = [String]()
    
    func getEvents(type : String, userGeoPoint: PFGeoPoint, miles: Double, numberOfEvents: Int){
        let query = PFQuery(className: "Event")
        print (currentLocation)
        if type == Categories.All {
            query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles)
        } else {
            query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles).whereKey("category", containsString: type)
        }
        query.orderByDescending("views")
        if numberOfEvents > 0 {
            query.limit = numberOfEvents
        }
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                var allEventsList = [Event]()
                if let event = objects as? [Event] {
                    allEventsList = event
                }
                self.eventsFactory[self.category!]?.removeAll()
                self.eventsFactory[self.category!] = allEventsList
                
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(Notifications.TopTenReady, object: self)
            }
        }
    }
    
    func getAllEvents(userGeoPoint: PFGeoPoint, miles: Double){
        let query = PFQuery(className: "Event")
         query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles)
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                var tempEventsFactory = [String:[Event]]()
                if let events = objects as? [Event] {
                    for event in events {
                        let eventCategory = event.category
                        if let _ = tempEventsFactory[eventCategory] {
                            tempEventsFactory[eventCategory]!.append(event)
                        } else {
                            tempEventsFactory[eventCategory] = [event]
                        }
                    }
                }
                self.eventsFactory = tempEventsFactory
                self.keys = Array(self.eventsFactory.keys).sort()
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(Notifications.EventFactoryReady, object: self)
            }
        }
    }
    
    func eventNameAtIndexPath(indexPath: NSIndexPath) -> Event {
        return (eventsFactory[(keys[indexPath.section])]!)[indexPath.row]
    }
    
    var numberOfSections : Int {
        return keys.count
    }
    
    func numberOfEventsInSection(section: Int) -> Int {
        return eventsFactory[(keys[section])]!.count
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