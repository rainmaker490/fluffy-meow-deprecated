//
//  Trending.swift
//  Beto
//
//  Created by Varun D Patel on 12/6/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

class Trending {
    static let sharedInstance = Trending()
    var currentLocation: PFGeoPoint?
    var category : String?
    var topTenTrendingEventsNearYou = [Event]()
    
    func getTopTen(category : String, userGeoPoint: PFGeoPoint, miles: Double){
        topTenTrendingEventsNearYou.removeAll()
        let query = PFQuery(className: "Event")
        query.whereKey("location", nearGeoPoint: userGeoPoint, withinMiles: miles).whereKey("category", containsString: category)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let event = objects as? [Event] {
                    self.topTenTrendingEventsNearYou = event
                }
                self.topTenTrendingEventsNearYou.sortInPlace({ $0.checkIns > $1.checkIns })
                for var i = 0 ; i < self.topTenTrendingEventsNearYou.count && self.topTenTrendingEventsNearYou.count > 10; i++ {
                    self.topTenTrendingEventsNearYou.removeLast()
                }
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