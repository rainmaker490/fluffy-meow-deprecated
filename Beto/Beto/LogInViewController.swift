//
//  LogInViewController.swift
//  Beto
//
//  Created by Varun D Patel on 11/16/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        facebookButton.layer.borderWidth = 1.0
        twitterButton.layer.borderWidth = 1.0
        passwordButton.layer.borderWidth = 1.0
        signUpButton.layer.borderWidth = 1.0
        
        facebookButton.layer.borderColor = ColorConstants.PulseBlueCGColor
        twitterButton.layer.borderColor = ColorConstants.PulseBlueCGColor
        passwordButton.layer.borderColor = ColorConstants.PulseBlueCGColor
        signUpButton.layer.borderColor = ColorConstants.PulseBlueCGColor
        
        facebookButton.layer.cornerRadius = 0.3 * facebookButton.bounds.size.width
        facebookButton.setImage(UIImage( named: "facebook.png"), forState: .Normal)
        facebookButton.clipsToBounds = true
        
        twitterButton.layer.cornerRadius = 0.3 * facebookButton.bounds.size.width
        twitterButton.setImage(UIImage( named: "twitter.png"), forState: .Normal)
        twitterButton.clipsToBounds = true
        
        passwordButton.layer.cornerRadius = 0.3 * facebookButton.bounds.size.width
        passwordButton.setImage(UIImage( named: "password.png"), forState: .Normal)
        passwordButton.clipsToBounds = true
        
        signUpButton.layer.cornerRadius = 0.3 * signUpButton.bounds.size.width
        signUpButton.setImage(UIImage( named: "signUp.png"), forState: .Normal)
        signUpButton.clipsToBounds = true
    }
}
