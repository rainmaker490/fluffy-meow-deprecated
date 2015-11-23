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
    var originalSignInViewFrameCenter : CGPoint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInPageTextFields = [username, password]
        signInPageButtons = [logInButton]
        SignInViewControllerHelper.setAllSignInPageTextFieldBorderWidth(signInPageTextFields!, borderWidth: 1.0)
        originalSignInViewFrameCenter = signInView.center
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                let x = self.logInButton.convertPoint(self.logInButton.center, fromView: self.view)
                self.signInView.center.y -= keyboardSize.height
                for views in self.signInView.subviews {
                    views.center.y -= 40.0
                }
                }, completion: nil)
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            // self.signInView.frame = originalSignInViewFrame!
        }
    }
}
