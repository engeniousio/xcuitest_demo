//
//  SingleTone.swift
//  iOrder
//
//  Created by Bay-QA on 30.03.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//
//

import Foundation

class SingletonStore : NSObject {
    
    fileprivate override init(){}
    
    static let sharedInstance = SingletonStore()
    
    var allplaces : [Place]?
    var place : Place?
    
    var tableID = -1
   
    var placeIdValidation = -1
    
    var qrCodeDetected = false
    
    var user : User?
    
    var newReservation: NewReservationProtocol?
    var newOrder: NewOrderProtocol?

    // when QR code captures the Id, we want to understand which place is this id for
    func makePlace(_ id: Int){
        guard let places = allplaces else { return }
        for myplace in places {
            if myplace.id == id {
                place = myplace
                break
            }
        }
    }
}



