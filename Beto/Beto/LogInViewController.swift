//
//  LogInViewController.swift
//  Beto
//
//  Created by Varun D Patel on 11/16/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LogInViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    var logInPageButtons : [UIButton]?
    
    override func viewDidLoad() {
        logInPageButtons = [facebookButton, twitterButton, passwordButton, signUpButton]
        
        LogInViewControllerHelper.setAllLogInPageButtonsBorderWidth(logInPageButtons!, borderWidth: 1.0)
        LogInViewControllerHelper.setAllLogInPageButtonsBorderColor(logInPageButtons!, borderColor: UIColor.whiteColor().CGColor)
        LogInViewControllerHelper.setAllLogInPageButtonsCornerRadius(logInPageButtons!, cornerRadius: 0.2 * facebookButton.bounds.size.width)

        self.facebookButton.delegate = self
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            print("yay here")
            // performSegueWithIdentifier("unwindToViewOtherController", sender: self)
        } else {
            facebookButton.readPermissions = FacebookConstants.ReadPermissions
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(FacebookConstants.ReadPermissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                // if new user {user signed up && logged in through fb} else { user logged in through facebook }
                user.isNew ? print("User signed up and logged in through Facebook!") : print("User logged in through Facebook!")
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
        /*if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // Navigate to other view
        }*/
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}
