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
    
    var event = EventsForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
        
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = "cancelTapped:"
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = "saveTapped:"
    }
    
    private func initializeForm() {
        form =
            TextRow("Event Title *").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
                }.onChange{ (row) -> () in
                    self.event.title = row.value
            }
            
            <<< TextRow("Location *").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
                }.onCellHighlight({ (cell, row) -> () in
                    
                })
                .onCellUnHighlight{ (cell, row) -> () in
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
            
            +++
            DateTimeInlineRow("Starts *") {
                $0.title = $0.tag
                }.onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends *")
                    if row.value?.compare(endRow.value!) == .OrderedDescending {
                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                        endRow.cell!.backgroundColor = .whiteColor()
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
            
            +++ Section("Event Type")
            <<< PickerInlineRow<String>("Event Category") {
                (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.options = Categories.CategoryOfEvents
                row.value = row.options[0]
                row.displayValueFor = {
                    guard let category = $0 else{
                        return nil
                    }
                    return "\(category)"
                }
                }.onChange{ (row) -> () in
                    self.event.type = row.value
        }
        
        form +++=
            URLRow("URL") {
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
        // Save to Parse
    }
}
