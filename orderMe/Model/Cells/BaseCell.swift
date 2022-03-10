//
//  BaseCell.swift
//  orderMe
//
//  Created by Bay-QA on 2/9/18.
//  Copyright © 2018 Bay-QA. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell, AccessibilityEnabling {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupAccessibilityLabels() {
        
    }
}
