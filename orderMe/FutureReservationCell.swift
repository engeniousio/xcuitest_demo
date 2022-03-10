//
//  FutureReserve.swift
//  orderMe
//
//  Created by Bay-QA on 6/2/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class FutureReservationCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var reserve: Reserve!
    
    var repquestion: RepeatQuestionProtocol?
    
    func configureCell(with reservation: Reserve) {
        self.placeNameLabel.text = reservation.place?.name
        self.dateLabel.text =      reservation.date?.dateString(ofStyle: .medium)
        self.timeLabel.text =      reservation.date?.timeString(ofStyle: .short)
        self.reserve =             reservation

    }
    
    @IBAction func deleteReserve(_ sender: AnyObject) {
        repquestion?.confirmationAlert(reserve)
    }
}
