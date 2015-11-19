//
//  LogInViewControllerUtils.swift
//  Beto
//
//  Created by Varun D Patel on 11/17/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import UIKit

class LogInViewControllerHelper {
    static func setAllLogInPageButtonsBorderWidth(logInPageButtons : [UIButton], borderWidth: CGFloat){
        for button in logInPageButtons {
            button.layer.borderWidth = borderWidth
        }
    }
    
    static func setAllLogInPageButtonsBorderColor(logInPageButtons : [UIButton], borderColor : CGColor){
        for button in logInPageButtons {
            button.layer.borderColor = borderColor
        }
    }
    
    static func setAllLogInPageButtonsCornerRadius(logInPageButtons : [UIButton], cornerRadius : CGFloat){
        for button in logInPageButtons {
            button.layer.cornerRadius = cornerRadius
            button.clipsToBounds = true
        }
    }

}