//
//  InfoViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/8/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

protocol EventDetails : class {
    var currentEvent : Event {
        get
    }
}

class InfoViewController: UIViewController {
    var completionBlock : (() -> Void)?
    weak var dataSource : EventDetails?
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    override func viewDidLoad() {
        eventTitle.text = dataSource?.currentEvent.title
    }
    
}
