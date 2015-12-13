//
//  InfoViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

protocol EventDetails : class {
    var currentEvent : Event {
        get
    }
}

class InfoViewController: UIViewController {
    var completionBlock : (() -> Void)?
    weak var dataSource : EventDetails?
    let userData = User.sharedInstance
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var addToFavorites: UIButton!
    @IBOutlet weak var pinToMap: UIButton!
    
    override func viewDidLoad() {
        addToFavorites.tintColor = .blackColor()
        eventTitle.text = dataSource?.currentEvent.title
        dataSource?.currentEvent.incrementKey("views", byAmount: 1)
        dataSource?.currentEvent.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                print("views incremented")
            } else {
                print(error)
            }
        })
        
        for event in userData.userEvents {
            if event.objectId == dataSource?.currentEvent.objectId {
                addToFavorites.setTitle("Remove From Favorites", forState: .Normal)
                break
            }
        }
        
    }
    
    @IBAction func addToFavoritesButtonPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Add to Favorites" {
            let event = dataSource?.currentEvent
            userData.user!.relationForKey("favoriteEvents").addObject(event!)
            userData.user!.saveInBackground()
            sender.setTitle("Remove From Favorites", forState: .Normal)
        } else {
            let relation = userData.user!.relationForKey("favoriteEvents")
            
            relation.removeObject(dataSource!.currentEvent)
            userData.user!.saveInBackground()
            sender.setTitle("Add to Favorites", forState: .Normal)
        }
        
    }
    
}
