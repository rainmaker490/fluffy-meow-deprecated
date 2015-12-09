//
//  Constants.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
//
//  Constants.swift
//  Beto
//
//  Created by Varun D Patel on 11/17/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import UIKit

struct ColorConstants {
    static let PulseBlue = UIColor(red: 169/255, green: 201/255, blue: 212/255, alpha: 1.0)
    static let PulseBlueCGColor = PulseBlue.CGColor
}

struct FacebookConstants {
    static let ReadPermissions = ["public_profile", "email", "user_friends"]
}

struct SignInPageImage {
    static let SignInButtonFilled = "SubmitFilled.png"
    static let SignInButtonUnFilled = "SubmitUnFilled.png"
}

struct Notifications {
    static let TopTenReady = "TopTenReady"
    static let CurrentLocationRecieved = "CurrentLocationRecieved"
}