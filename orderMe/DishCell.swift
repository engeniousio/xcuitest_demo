//
//  DishCell.swift
//  iOrder
//
//  Created by Bay-QA on 03.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class DishCell: UITableViewCell {
    
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    var itemsCount = 0
    var dish: Dish!
    var cellDelegate: BucketCellProtocolAddDelete?
    var infoD: InfoDishProtocol?
    
    override func awakeFromNib() {
        self.infoButton.tintColor = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view.tintColor
    }
    
    @IBAction func addItem(_ sender: AnyObject) {
        itemsCount += 1
        numberOfItemsLabel.text = String(itemsCount)
        addToBucket(sender) // add to Bucket
    }
    
    @IBAction func infoBut(_ sender: AnyObject) {
        infoD?.showInfoDish(self.dish)
    }
    
    
    @IBAction func deleteItem(_ sender: AnyObject) {
        if itemsCount > 0 {
            itemsCount -= 1
            numberOfItemsLabel.text = String(itemsCount)
            deleteFromBucket(sender)
        }
    }
    
    func addToBucket(_ sender: AnyObject) {
        guard let dish = dish else { return }
        Bucket.sharedInstance.addDish(dish: dish)
        cellDelegate?.addDish(dish)
    }
    
    func deleteFromBucket(_ sender: AnyObject) {
        guard let dish = dish else { return }
        Bucket.sharedInstance.deleteDish(dish: dish)
        cellDelegate?.deleteDish(dish)
    }
}
