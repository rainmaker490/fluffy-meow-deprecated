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
    var userEvents = [Event]()
    
    func saveUser() {
        user!.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("user saved")
            } else {
                print(error?.description)
            }
        }
    }
        
    func getFavorites(){
        let query = user!["favoriteEvents"].query()
        query.findObjectsInBackgroundWithBlock { (events, error) -> Void in
            if error == nil {
                if let favorites = events as? [Event] {
                    self.userEvents = favorites
                }
            }
        }
    }
}

struct SignUpUser {
    var username: String?
    var password: String?
    var verifyPassword: String?
    var email: String?
    var image: UIImage?
}