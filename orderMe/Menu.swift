//
//  Menu.swift
//  orderMe
//
//  Created by Bay-QA on 12/17/16.
//  Copyright © 2016 Bay-QA. All rights reserved.
//


import ObjectMapper

class Menu: Mappable {

    var categories : [Category]?
    var dishes : [Dish]?
    
    
    required init?(map: Map) {
        
    }
    
    init (categories: [Category], dishes: [Dish]){
        self.categories = categories
        self.dishes = dishes
        
    }
    
    // Mark : Mappable
    func mapping(map: Map) {
        categories  <- map["categories"]
        dishes       <- map["dishes"]
    }
    
    
}
