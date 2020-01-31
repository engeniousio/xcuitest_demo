//
//  CategoryCell.swift
//  iOrder
//
//  Created by Boris Gurtovyy on 03.04.16.
//  Copyright © 2016 Boris Gurtovoy. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
        
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    var category: Category!

}
