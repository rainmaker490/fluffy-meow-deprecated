//
//  MoreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Eureka
import Parse

protocol GetAddedEvent : class{
    var addedEvent : PFObject {
        get
    }
}
class MoreViewController: FormViewController {
    
    let userData = User.sharedInstance
    weak var dataSource : GetAddedEvent?
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeForm()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        userData.user!.saveInBackground()
    }
    
    private func initializeForm() {
        form  +++= Section("User And Events Info")
            <<< ButtonRow("My Profile") { row in
                    row.title = row.tag
                    row.presentationMode = .SegueName(segueName: "MyProfileSegue", completionCallback: {  vc in vc.dismissViewControllerAnimated(true, completion: nil) })
                }.cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Profile.png")
                }
            
            <<< ButtonRow("Add an Event") {
                    $0.title = $0.tag
                    $0.presentationMode = .SegueName(segueName: "AddEventSegue", completionCallback: nil)
                }.cellSetup { cell, row in
                    cell.imageView?.image = UIImage(named: "Plus.png")
                }
        
        form +++= Section("Properties")
            <<< SegmentedRow<Int>(){
                        $0.title = "Events Distance (Miles)"
                        $0.options = [10, 25, 50]
                        $0.value = userData.user!["distance"] as? Int
                        $0.cell.tintColor = .blueColor()
                    }.onChange{ (row) -> () in
                        self.userData.user!["distance"] = row.value
                    }
        form +++= Section("User Options")
            <<< ButtonRow("Log Out") { (row: ButtonRow) in
                    row.title = row.tag
                    row.cell.tintColor = .redColor()
                }.onCellSelection{ (cell, row) -> () in
                    self.logOut()
                }
        
        // Space so footer does not cover up Logout button
        form +++= Section()
        form +++= Section()
    }
    
    private func logOut(){
        SharedInstances.searchInstance = nil
        SharedInstances.trendingInstance = nil
        PFUser.logOut()
        SharedInstances.searchInstance = Trending()
        SharedInstances.trendingInstance = Trending()
        let betoTabViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewControllerID") as! LogInViewController
        self.presentViewController(betoTabViewController, animated: true, completion: nil)
    }
    
    /*
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageAndLabelTableViewCell") as! ImageAndLabelTableViewCell
            cell.actionLabel.text = "My Profile"
            cell.actionImage.image = UIImage(named: "")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageAndLabelTableViewCell") as! ImageAndLabelTableViewCell
            cell.actionLabel.text = ""
            return cell
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "AddEvent":
            let addEvents = segue.destinationViewController as! NativeEventNavigationController
            addEvents.completionCallback = {  vc in vc.dismissViewControllerAnimated(true, completion: nil) })
            presentViewController(addEvents, animated: true, completion: nil)
            break
        default:
            assert(false, "Unhandled Segue")
        }
    }
    */
}

