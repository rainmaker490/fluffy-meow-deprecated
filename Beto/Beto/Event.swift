//
//  TopTrending.swift
//  Beto
//
//  Created by Varun D Patel on 12/7/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

class Event: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Event"
    }
    
    @NSManaged var category : String
    @NSManaged var views : Int
    @NSManaged var eventDate : NSDate
    @NSManaged var location : PFGeoPoint
    @NSManaged var expirationDate : NSDate
    @NSManaged var title : String
    @NSManaged var locationString : String
}