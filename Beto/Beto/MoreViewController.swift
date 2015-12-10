//
//  MoreViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Eureka

class MoreViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImageRow.defaultCellUpdate = { cell, row in
            cell.accessoryView?.layer.cornerRadius = 17
            cell.accessoryView?.frame = CGRectMake(0, 0, 34, 34)
        }
        
        form  +++=
            
            Section()
            
            <<< ButtonRow("View My Profile") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "AddEvent", completionCallback: nil)
            }
            
            <<< ButtonRow("Native iOS Event Form") { row in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "NativeEventsFormNavigationControllerSegue", completionCallback:{  vc in vc.dismissViewControllerAnimated(true, completion: nil) })
            }
            
            <<< ButtonRow("Accesory View Navigation") { (row: ButtonRow) in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "AccesoryViewControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Custom Cells") { (row: ButtonRow) -> () in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "CustomCellsControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Customization of rows with text input") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "FieldCustomizationControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Hidden rows") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "HiddenRowsControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Disabled rows") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "DisabledRowsControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Formatters") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "FormattersControllerSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Inline rows") { (row: ButtonRow) -> Void in
                row.title = row.tag
                row.presentationMode = .SegueName(segueName: "InlineRowsControllerSegue", completionCallback: nil)
        }
    }
    
    /*override func viewDidLoad() {
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
    }*/
}
