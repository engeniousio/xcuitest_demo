//
//  BucketCell.swift
//  iOrder
//
//  Created by Bay-QA on 06.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class BucketCell: UITableViewCell {
    
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var dish: Dish?
    
    var numberOfItems = 0
    
    var bucketCellDelegateAddDelete: BucketCellProtocolAddDelete?
    
    @IBAction func plusDishButton() {
        
        guard let dish = dish else { return }
        guard let amount = Int(amountLabel.text!) else { return }
        
        let newAmount = amount + 1
        amountLabel.text = newAmount.description
        
        guard let oldPrice = Double(priceLabel.text!) else { return }
        
        let newPrice = newAmount != 1 ? oldPrice * Double(newAmount) / Double(newAmount - 1) : dish.price
        
        priceLabel.text = newPrice?.description
        
        Bucket.sharedInstance.addDish(dish: dish) // updating Bucket
        bucketCellDelegateAddDelete?.addDish(dish)  // updating sum label in Categories
    }
    
    @IBAction func minusDishButton() {
        
        guard let dish = dish else { return }
        guard let amount = Int(amountLabel.text!) else { return }
        guard amount > 0 else { return }
        
        let newAmount = amount - 1
        amountLabel.text = newAmount.description
        
        guard let oldPrice = Double(priceLabel.text!) else { return }
        
        let newPrice = oldPrice * Double(newAmount) / (Double(newAmount) + 1)
        
        priceLabel.text = newPrice.description
        
        Bucket.sharedInstance.deleteDish(dish: dish) // updating Bucket
    bucketCellDelegateAddDelete?.deleteDish(dish) // updating sum label in Categories
        
    }
 
}
