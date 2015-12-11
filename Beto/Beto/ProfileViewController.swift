//
//  ProfileViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    let userData = User.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text = String(userData.user!["username"])
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
