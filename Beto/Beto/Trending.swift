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
    static var trendingInstance = Trending()
    static var mapInstance = Trending()
    static var searchInstance = Trending()
}

protocol CurrentLocationDelegate : class {
    var currentLocation : PFGeoPoint {
        get
    }
}

class Trending : NilLiteralConvertible {
    
    
    weak var dataSource : CurrentLocationDelegate?
    
    var currentLocation: PFGeoPoint?
    var category : String?
    private var trendingFactory = [Event]()
    var eventsFactory = [String:[Event]]()
    private var keys = [String]()
    
    func getEvents(type : String, miles: Double, numberOfEvents: Int){
        let query = PFQuery(className: "Event")
        if type == Categories.All {
            query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles)
        } else {
            query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles).whereKey("category", containsString: type)
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
    
    func getAllEvents(miles: Double){
        let query = PFQuery(className: "Event")
         query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles)
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
                
                for key in self.keys {
                    self.eventsFactory[key]!.sortInPlace({ $0.title < $1.title })
                }
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(Notifications.EventFactoryReady, object: self)
            }
        }
    }
    
    func getKey(index: Int) -> String {
        return keys[index]
    }
    
    func titleForSection(section: Int) -> String {
        return keys[section]
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
                print(geoPoint)
                let notifications = NSNotificationCenter.defaultCenter()
                notifications.postNotificationName(Notifications.CurrentLocationRecieved, object: self)
            }
        }
    }
    
    init(){}
    
    required init(nilLiteral: ()) {
        
    }
    
}