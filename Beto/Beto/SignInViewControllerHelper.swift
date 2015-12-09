//
//  SignInViewControllerHelper.swift
//  Beto
//
//  Created by Varun D Patel on 11/18/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import Foundation
import UIKit

class SignInViewControllerHelper {
    static func setAllSignInPageTextFieldBorderWidth(signInPageTextFields : [UITextField], borderWidth: CGFloat){
        for textField in signInPageTextFields {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
            bottomBorder.backgroundColor = UIColor.blackColor().CGColor
            textField.layer.addSublayer(bottomBorder)
            // textField.layer.borderWidth = borderWidth
        }
    }
    
    /*static func setAllSignInPageTextFieldBorderColor(signInPageTextFields : [UITextField], borderColor : CGColor){
    for textField in signInPageTextFields {
    textField.layer.borderColor = borderColor
    }
    }*/
}