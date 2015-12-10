//
//  User.swift
//  Beto
//
//  Created by Varun D Patel on 12/10/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import Parse

class User {
    static let sharedInstance = User()
    
    let user = PFUser.currentUser()
    
    func saveUser(){
        user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("user saved")
            } else {
                print(error?.description)
            }
        }
    }
}