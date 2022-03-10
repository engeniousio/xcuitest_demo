//
//  ReservationView.swift
//  orderMe
//
//  Created by Bay-QA on 2/14/18.
//  Copyright © 2018 Bay-QA. All rights reserved.
//

import UIKit

protocol ReservationViewDelegate: class {
    func segmentViewDidChange(to segment: Int) 
}

class ReservationView: UIView {
    
    var segmentedControl: UISegmentedControl!
    weak var delegate: ReservationViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.segmentedControl = UISegmentedControl(items: [Reservation.past.text, Reservation.current.text])
        
        self.layer.insertSublayer(self.themeGradient(), at: 0)
        self.addSubview(segmentedControl)
        
        self.segmentedControl.clipsToBounds = true
        self.segmentedControl.layer.borderColor = UIColor.white.cgColor
        self.segmentedControl.layer.borderWidth = 1.5
        self.segmentedControl.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        self.segmentedControl.setTintColorForSelectedViews(.white)
        
        self.segmentedControl.addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
        
    }
    
    override func layoutSubviews() {
        var frame: CGRect {
            return self.segmentedControl.frame
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        self.segmentedControl.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height + 3.0)
        self.segmentedControl.center = CGPoint(x: self.bounds.size.width/2, y: (self.bounds.size.height/2) + (statusBarHeight / 2))
        self.segmentedControl.layer.cornerRadius = frame.height / 2

    }
    
    @objc func valueChanged(sender: UISegmentedControl) {
        delegate?.segmentViewDidChange(to: sender.selectedSegmentIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
