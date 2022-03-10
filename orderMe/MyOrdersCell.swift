//
//  MyOrdersCell.swift
//  orderMe
//
//  Created by Bay-QA on 6/4/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class MyOrdersCell: UITableViewCell {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    func configureCell(with order: Order) {
        self.placeNameLabel.text = order.place?.name
        self.dateLabel.text = order.created?.dateString(ofStyle: .short)
        self.totalLabel.text = "$\(String(describing: order.sum!))"
    }
}
