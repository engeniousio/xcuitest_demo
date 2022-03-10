//
//  DataStructs.swift
//  orderMe
//
//  Created by Bay-QA on 2/13/18.
//  Copyright © 2018 Bay-QA. All rights reserved.
//
import UIKit

// This is comment from Boris

enum PlaceCellDataStore {
    case detectTable
    case menu
    case reservation
    case callAWaiter
    case phone(Place)
    case address(Place)
    
    var data: (text: String, image: UIImage) {
        switch self {
        case .detectTable:        return ("Detect table",      #imageLiteral(resourceName: "qrcode"))
        case .menu:               return ("Menu",              #imageLiteral(resourceName: "list"))
        case .reservation:        return ("Reservation",       #imageLiteral(resourceName: "folkandknife"))
        case .callAWaiter:        return ("Call a waiter",     #imageLiteral(resourceName: "waiter"))
        case .phone(let place):   return (place.phone ?? "",   #imageLiteral(resourceName: "phone"))
        case .address(let place): return (place.address ?? "", #imageLiteral(resourceName: "adress"))
        }
    }
    
    static func element(by index: Int, for place: Place) -> PlaceCellDataStore {
        switch index {
        case 0: return .detectTable
        case 1: return .menu
        case 2: return .reservation
        case 3: return .callAWaiter
        case 4: return .phone(place)
        case 5: return .address(place)
        default:
            fatalError("Unexpected index for Place")
        }
    }
    
    static var caseCount: Int {
        return 6
    }
}

