//
//  MoreTableViewCell.swift
//  Beto
//
//  Created by Varun D Patel on 12/7/15.
//  Copyright © 2015 Varun D Patel. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageIcon: UIView!
    
    @IBOutlet weak var imageLabel: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
