//
//  EventViewController.swift
//  Beto
//
//  Created by Varun D Patel on 12/9/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit
import Eureka

class NativeEventNavigationController: UINavigationController, RowControllerType {
    var completionCallback : ((UIViewController) -> ())?
}

class EventViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeForm()
        
        self.navigationItem.leftBarButtonItem?.target = self
        self.navigationItem.leftBarButtonItem?.action = "cancelTapped:"
    }

    private func initializeForm() {
        form =
            TextRow("Event Title *").cellSetup { cell, row in
                cell.textField.placeholder = row.tag
            }
            
            <<< TextRow("Location *").cellSetup {
                $0.cell.textField.placeholder = $0.row.tag
            }
            
            +++
            
            DateTimeInlineRow("Starts *") {
                $0.title = $0.tag
                $0.value = NSDate().dateByAddingTimeInterval(60*60*24)
                }
                .onChange { [weak self] row in
                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends *")
                    if row.value?.compare(endRow.value!) == .OrderedDescending {
                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
                        endRow.cell!.backgroundColor = .whiteColor()
                        endRow.updateCell()
                    }
                }
                .onExpandInlineRow { cell, row, inlineRow in
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
                }
                .onChange { [weak self] row in
                    let startRow: DateTimeInlineRow? = self?.form.rowByTag("Starts *")
                    row.cell!.backgroundColor =  row.value?.compare(startRow!.value!) == .OrderedAscending ? .redColor() : .whiteColor()
                    row.updateCell()
                }
                .onExpandInlineRow { cell, row, inlineRow in
                    inlineRow.cellUpdate { cell, dateRow in
                        cell.datePicker.datePickerMode = .DateAndTime
                    }
                    let color = cell.detailTextLabel?.textColor
                    row.onCollapseInlineRow { cell, _, _ in
                        cell.detailTextLabel?.textColor = color
                    }
                    cell.detailTextLabel?.textColor = cell.tintColor
        }
        
        form +++=
            
            URLRow("URL") {
                $0.placeholder = "URL"
            }
            
            <<< TextAreaRow("Description") {
                $0.placeholder = "Description"
        }
        
    }
    
    func cancelTapped(barButtonItem: UIBarButtonItem) {
        (navigationController as? NativeEventNavigationController)?.completionCallback?(self)
    }
}
