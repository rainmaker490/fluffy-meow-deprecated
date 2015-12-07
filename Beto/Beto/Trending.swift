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
    var currentLocation : PFGeoPoint?
    var category : String?
    var trendingEventsNearYou = [String]()
    
    private init(){}
    
}