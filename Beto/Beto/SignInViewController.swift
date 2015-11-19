//
//  SignInViewController.swift
//  Beto
//
//  Created by Varun D Patel on 11/18/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    var signInPageTextFields : [UITextField]?
    var signInPageButtons : [UIButton]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInPageTextFields = [username, password]
        signInPageButtons = [logInButton]
        SignInViewControllerHelper.setAllSignInPageTextFieldBorderWidth(signInPageTextFields!, borderWidth: 1.0)
    }



    @IBAction func logInButtonPressed(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
            } else {
                print(error?.localizedDescription)
            }
        }
    }

    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
