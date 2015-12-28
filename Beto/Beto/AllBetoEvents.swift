//
//  AllBetoEvents.swift
//  Beto
//
//  Created by Varun D Patel on 12/24/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

class AllBetoEvents: NilLiteralConvertible {
    
    weak var dataSource : CurrentLocationDelegate?
    var eventsFactory = [String:[Event]]()
    private var keys = [String]()
    
    func getAllEvents(miles: Double, sendNotification: Bool){
        let query = PFQuery(className: "Event")
        query.whereKey("location", nearGeoPoint: dataSource!.currentLocation, withinMiles: miles)
        query.findObjectsInBackgroundWithBlock{ (objects, error) -> Void in
            if error == nil {
                if let events = objects as? [Event] {
                    for event in events {
                        let eventCategory = event.category
                        if let _ = self.eventsFactory[eventCategory] {
                            self.eventsFactory[eventCategory]!.append(event)
                        } else {
                            self.eventsFactory[eventCategory] = [event]
                        }
                    }
                }
                self.keys = Array(self.eventsFactory.keys).sort()
                
                for key in self.keys {
                    self.eventsFactory[key]!.sortInPlace({ $0.title < $1.title })
                }
                if sendNotification {
                    let notification = NSNotificationCenter.defaultCenter()
                    notification.postNotificationName(Notifications.EventFactoryReady, object: self)
                }
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
    
    init(){}
    
    required init(nilLiteral: ()) {}
    
}