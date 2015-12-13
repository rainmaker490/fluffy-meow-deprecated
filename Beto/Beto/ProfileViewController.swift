//
//  ProfileViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    let userData = User.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstName.text = userData.user!.username
        
    }

    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func test() {
        let userPicture = userData.user!["avatar"]! as! PFFile
        userPicture.getDataInBackgroundWithBlock { (picture, error) -> Void in
            if error != nil {
                self.avatar.image = UIImage(data: picture!)
            }
        }
        
        
    }
    
}
