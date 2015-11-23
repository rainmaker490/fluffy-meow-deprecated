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

    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var invalidLogIn: UILabel!
    
    var signInPageTextFields : [UITextField]?
    var signInPageButtons : [UIButton]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInPageTextFields = [username, password]
        signInPageButtons = [logInButton]
        SignInViewControllerHelper.setAllSignInPageTextFieldBorderWidth(signInPageTextFields!, borderWidth: 1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    @IBAction func logInButtonPressed(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.invalidLogIn.hidden = true
                self.logInButton.setImage(UIImage(named: SignInPageImage.SignInButtonFilled), forState: .Normal)
                // Do stuff after successful login.
            } else {
                self.invalidLogIn.hidden = false
            }
        }
    }
    
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
