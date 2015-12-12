//
//  SignUpViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/11/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Eureka

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
                    }
                <<< EmailRow() {
                        $0.title = "email"
                    }
 
        form +++= Section("Password")
                <<< PasswordRow() {
                        $0.title = "Password: "
                    }
                <<< PasswordRow("Verify Password") {
                        $0.title = "Verify Password: "
                    }
        
        form +++= Section("Image :")
                <<< ImageRow("Event Image").cellSetup{ (cell, row) -> () in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRectMake(0, 0, 50, 50)
                    cell.detailTextLabel?.tintColor = .grayColor()
                    cell.row.value = UIImage(named: "Camera.png")
                    cell.row.title = "Set Profile Image-Tap Me"
                }.onChange{ (image) -> () in
                    if let imageValue = image.value {
                        self.userSignUp.image = imageValue
                    }
                }
        
    }
    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
