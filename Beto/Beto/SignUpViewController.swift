//
//  SignUpViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/11/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Eureka
import Parse

class SignUpViewController: FormViewController {
    
    var userSignUp = SignUpUser()
    
    override func viewDidLoad() {
        initializeForm()
        super.viewDidLoad()
        
        tableView!.estimatedRowHeight = tableView!.rowHeight
        tableView!.rowHeight = UITableViewAutomaticDimension
    }
    
    private func initializeForm() {
        form +++= Section("User")
                <<< NameRow() {
                        $0.title =  "username"
                        $0.placeholder = "beto"
                        $0.onChange{ (row) -> () in
                            self.userSignUp.username = row.value
                            row.title = "username"
                        }
                    }
                <<< EmailRow() {
                        $0.title = "email"
                        $0.placeholder = "beto@beto.io"
                        $0.onChange { (row) -> () in
                            self.userSignUp.email = row.value
                        }
                    }
 
        form +++= Section("Password")
                <<< PasswordRow() {
                        $0.title = "Password: "
                        $0.placeholder = "***"
                        $0.onChange { row -> () in
                            self.userSignUp.password = row.value
                        }
                    }
                <<< PasswordRow("Verify Password") {
                        $0.title = "Verify Password: "
                        $0.placeholder = "***"
                        $0.onChange { row -> () in
                            self.userSignUp.verifyPassword = row.value
                        }
                    }
        
        form +++= Section("Image :")
                <<< ImageRow("Event Image").cellSetup{ (cell, row) -> () in
                        cell.accessoryView?.layer.cornerRadius = 17
                        cell.accessoryView?.frame = CGRectMake(0, 0, 50, 50)
                        cell.detailTextLabel?.tintColor = .grayColor()
                        cell.row.value = UIImage(named: "Camera.png")
                        cell.row.title = "Set Profile Image-Tap Me"
                    }.onChange{ (image) -> () in
                        self.userSignUp.image = image.value
                    }
        
        form +++= Section("Sign up: ")
                <<< ButtonRow("Sign up && Login") {
                        $0.title = $0.tag
                    }.cellSetup { cell, row in
                        cell.tintColor = .blueColor()
                        cell.imageView?.image = UIImage(named: "SignUpButton.png")
                    }.onCellSelection{ (cell, row) -> () in
                        self.signUp()
                    }
    }
    
    // #TODO:
    // check if email is unique
    func signUp(){
        var feedbackString : String = ""
        var isValidFields = userSignUp.verifyPassword! == userSignUp.password!
        feedbackString += !isValidFields ? "Passwords do not match!" : ""
        isValidFields = isValidFields && userSignUp.username != nil
        feedbackString += !isValidFields ? "\nUsername field missing" : ""
        isValidFields = isValidFields && userSignUp.email != nil
        feedbackString += !isValidFields ? "\nEmail field missing" : ""
        
        if isValidFields {
            let user = PFUser()
            user.username = userSignUp.username!.lowercaseString
            user.password = userSignUp.password
            
            if let image = userSignUp.image {
                let imageData = image.mediumQualityJPEGNSData
                let imageFile = PFFile(name:"profilePicture.png", data: imageData)
                user["avatar"] = imageFile
            }
            
            user["distance"] = 10
            user.signUpInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    // TODO: check if email is unique
                    PFUser.logInWithUsernameInBackground(self.userSignUp.username!.lowercaseString, password: self.userSignUp.password!) {
                        (user: PFUser?, error: NSError?) -> Void in
                        if error == nil {
                            let betoTabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BetoTabViewController") as! BetoTabViewController
                            self.presentViewController(betoTabViewController, animated: true, completion: nil)
                        }
                    }
                } else {
                    self.presentAlertView("Invalid username 😵", message: "Non-unique username || email")
                }
            }
        } else {
            presentAlertView("Incomplete Parameters", message: feedbackString)
        }
    }
    
    func presentAlertView(title: String, message: String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
