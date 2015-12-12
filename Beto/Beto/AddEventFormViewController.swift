//
//  EventViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import MapKit
import Eureka
import Parse

class NativeEventNavigationController: UINavigationController, RowControllerType {
    var completionCallback : ((UIViewController) -> ())?
}

class AddEventFormViewController: FormViewController {
    
    let userData = User.sharedInstance
    var event = EventsForm()
    var relationalEvent = PFObject(className: "Event")
    
    override func viewDidLoad() {
        initializeForm()
        
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = "cancelTapped:"
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = "saveTapped:"
        super.viewDidLoad()
    }
    
    private func initializeForm() {
        form +++=
            /*Section(footer: "These are 10 ButtonRow rows") {
                   /$0.header = HeaderFooterView<EurekaLogoView>(HeaderFooterProvider.Class)
            }*/
            Section("Image :")
                <<< ImageRow("Event Image").cellSetup{ (cell, row) -> () in
                        cell.accessoryView?.layer.cornerRadius = 17
                        cell.accessoryView?.frame = CGRectMake(0, 0, 50, 50)
                        cell.detailTextLabel?.tintColor = .grayColor()
                        cell.row.value = UIImage(named: "Camera.png")
                        cell.row.title = "Set Event Image-Tap Me"
                    }.onChange{ (image) -> () in
                        if let imageValue = image.value {
                            self.event.image = imageValue
                        }
                    }
        
        form +++= Section("Title and Location")
                <<< TextRow("Event Title *").cellSetup { cell, row in
                        cell.textField.placeholder = row.tag
                    }.onChange{ (row) -> () in
                        self.event.title = row.value
                    }
            
                <<< TextRow("Location *").cellSetup {
                        $0.cell.textField.placeholder = $0.row.tag
                    }.onChange{ (row) -> () in
                        self.event.locationString = row.value
                        if let location = row.value {
                            CLGeocoder().geocodeAddressString(location) { (placemarks, error) -> Void in
                                if((error) != nil){
                                    print("Error", error)
                                }
                                if let placemark = placemarks?.first {
                                    self.event.location = placemark.location!.coordinate
                                }
                            }
                        }
                    }
            
        form +++= Section("Dates")
                <<< DateTimeInlineRow("Starts *") {
                        $0.title = $0.tag
                        $0.value = NSDate().dateByAddingTimeInterval(60*60*24)
                        self.event.startDate = $0.value
                    }.onChange { [weak self] row in
                        let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends *")
                        if row.value?.compare(endRow.value!) == .OrderedDescending {
                            endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                            endRow.updateCell()
                        }
                        self?.event.startDate = row.value
                    }.onExpandInlineRow { cell, row, inlineRow in
                        inlineRow.cellUpdate { cell, dateRow in
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                        let color = cell.detailTextLabel?.textColor
                        row.onCollapseInlineRow { cell, _, _ in
                            cell.detailTextLabel?.textColor = color
                        }
                        cell.detailTextLabel?.textColor = cell.tintColor
                    }
                <<< DateTimeInlineRow("Ends *"){
                        $0.title = $0.tag
                        $0.value = NSDate().dateByAddingTimeInterval(60*60*25)
                        self.event.endDate = $0.value
                    }.onChange { [weak self] row in
                        let startRow: DateTimeInlineRow? = self?.form.rowByTag("Starts *")
                        row.cell!.backgroundColor =  row.value?.compare(startRow!.value!) == .OrderedAscending ? .redColor() : .whiteColor()
                        row.updateCell()
                        self?.event.endDate = row.value
                    }.onExpandInlineRow { cell, row, inlineRow in
                        inlineRow.cellUpdate { cell, dateRow in
                            cell.datePicker.datePickerMode = .DateAndTime
                        }
                        let color = cell.detailTextLabel?.textColor
                        row.onCollapseInlineRow { cell, _, _ in
                            cell.detailTextLabel?.textColor = color
                        }
                        cell.detailTextLabel?.textColor = cell.tintColor
                    }
            
        form +++= Section("Event Type")
                <<< AlertRow<String>() {
                        $0.title = "Event Category"
                        $0.selectorTitle = "Event Category"
                        $0.options = Categories.CategoryOfEvents
                    }.onChange { row in
                        print(row.value)
                        self.event.type = row.value
                    }.onPresent{ _, to in
                        to.view.tintColor = .grayColor()
                    }
        form +++= Section("Other")
                <<< URLRow("URL") {
                        $0.placeholder = "URL"
                    }.onChange{ (row) -> () in
                        self.event.url = String(row.value)
                    }
                <<< TextAreaRow("Description") {
                        $0.placeholder = "Description"
                    }.onChange{ (row) -> () in
                        self.event.description = row.value
                    }
    }
    
    func cancelTapped(barButtonItem: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveTapped(sender: UIBarButtonItem){
        let eventIsValid = isEventValid(event)
        if eventIsValid {
            let newEvent = PFObject(className: "Event")
            newEvent["title"] = event.title
            newEvent["eventDate"] = event.startDate
            newEvent["expirationDate"] = event.endDate
            newEvent["category"] = event.type
            newEvent["location"] = PFGeoPoint(latitude: event.location!.latitude, longitude: event.location!.longitude)
            newEvent["views"] = 1
            newEvent["locationString"] = event.locationString
            
            if let image = event.image {
                let imageData = image.mediumQualityJPEGNSData
                let imageFile = PFFile(name:"eventImage.png", data: imageData)
                newEvent["eventPhoto"] = imageFile
            }
            relationalEvent = newEvent
            newEvent.saveInBackgroundWithBlock{ (success, error) -> Void in
                if success {
                    print("New event saved")
                    self.userData.user!.relationForKey("myCreatedEvents").addObject(self.relationalEvent)
                    self.userData.user!.saveInBackground()
                } else {
                    print("error saving new event")
                }
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            presentAlertView()
        }
    }
    
    func isEventValid(event: EventsForm)-> Bool{
        var eventIsValid = event.title != nil
        eventIsValid = eventIsValid && (event.startDate != nil)
        eventIsValid = eventIsValid && (event.endDate != nil)
        eventIsValid = eventIsValid && (event.location != nil)
        eventIsValid = eventIsValid && (event.type != nil)
        eventIsValid = eventIsValid && (event.startDate?.compare(event.endDate!) == .OrderedAscending)
        eventIsValid = eventIsValid && (event.startDate?.compare(NSDate()) == .OrderedDescending)
        return eventIsValid
    }
    
    func presentAlertView(){
        let alertView = UIAlertController(title: "Incomplete Parameters", message: "Missing Required Fields \n -Fields marked with * \n -Is Address Correct?", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
}
