//
//  BetoObjects.swift
//  Beto
//
//  Created by Varun D Patel on 12/23/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation

class SharedInstances {
    static var trendingInstance = Trending()
    static var searchInstance = Trending()
    static var categoriesInstance = Category()
    static var allEventsInstance = AllBetoEvents()
}

struct Category : NilLiteralConvertible {
    var trending: String?
    var explore: String?
    var search: String?
    init(nilLiteral: ()) {}
    private init() {}
}
