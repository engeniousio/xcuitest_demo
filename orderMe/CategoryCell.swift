//
//  CategoryCell.swift
//  iOrder
//
//  Created by Bay-QA on 03.04.16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
        
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var category: Category!

}
