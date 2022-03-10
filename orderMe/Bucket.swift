//
//  Bucket.swift
//  iOrder
//
//  Created by Bay-QA on 04.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import Foundation

class Bucket: NSObject {
    
    fileprivate override init(){}
    
    static let sharedInstance = Bucket()
    
    var myBucket : [Dish : Int] = [:]
    var allSum : Double = 0
    
    // add dish to Bucket
    func addDish (dish : Dish) {
        let amountOfDish = myBucket.keys.contains(dish) ? myBucket[dish]! + 1 : 1  // if already existed - incrementing amount on 1, else adding new dish with amount of 1

        myBucket[dish] = amountOfDish
        if let price = dish.price {
            allSum += price
        }
    }
    
    //delete dish from Bucket
    func deleteDish(dish: Dish) {
        guard myBucket.keys.contains(dish) else { return }
        var amountOfDish = myBucket[dish]!
        guard amountOfDish > 0 else { return }
        amountOfDish = amountOfDish - 1
        myBucket[dish] = amountOfDish
        if let price = dish.price {
            if (amountOfDish == 0) {
                allSum = 0.0
            }
            else {
                allSum -= price
            }
        }
    }
    
}
